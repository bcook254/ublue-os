#!/usr/bin/bash

# A script to install an RPM from the latest Github release for a project.
# Maintained by the ublue-os project at https://github.com/ublue-os/main/blob/main/github-release-install.sh
#
#   Copyright 2024 Universal Blue (https://universal-blue.org)
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# REPO is the pair of URL components for organization/projectName in Github URL
# example: https://github.com/wez/wezterm/releases
#   REPO would be "wez/wezterm"
#
# ASSET_FILTER is used to select the specific RPM. Typically this can just be the arch
#   such as 'x86_64' but sometimes a specific filter is required when multiple match.
# example: wezterm builds RPMs for different distros so we must be more specific.
#   ASSET_FILTER of "fedora37.x86_64" gets the x86_64 RPM build for fedora37

usage() {
  echo "TODO"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --asset-filter*)
      if [[ "$1" != *=* ]]; then shift; fi # Value is next arg if not `=`
      ASSET_FILTER="${1#*=}"
      ;;
    --repository*)
      if [[ "$1" != *=* ]]; then shift; fi
      REPO="${1#*=}"
      ;;
    --tag-override*)
      if [[ "$1" != *=* ]]; then shift; fi
      TAG="tags/${1#*=}"
      ;;
    --download-only)
      DOWNLOAD_ONLY="true"
      ;;
    --output-dir*)
      if [[ "$1" != *=* ]]; then shift; fi
      OUTPUT_DIR="${1#*=}"
      ;;
    --output-file*)
      if [[ "$1" != *=* ]]; then shift; fi
      OUTPUT_FILE="${1#*=}"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument '$1'\n"
      usage
      exit 1
      ;;
  esac
  shift
done

if [ -z "${REPO}" ]; then
  usage
  exit 2
fi

if [ -z "${ASSET_FILTER}" ]; then
  usage
  exit 2
fi

TAG="${TAG:-latest}"
OUTPUT_DIR="${OUTPUT_DIR:-.}"

set -ouex pipefail

API_JSON=$(mktemp /tmp/api-XXXXXXXX.json)
API="https://api.github.com/repos/${REPO}/releases/${TAG}"

# retry up to 5 times with 5 second delays for any error included HTTP 404 etc
if ! curl --fail --retry 5 --retry-delay 5 --retry-all-errors -sL ${API} -o ${API_JSON}; then
  exit 3
fi
RPM_URLS=($(cat ${API_JSON} \
  | jq \
    -r \
    --arg asset_filter "${ASSET_FILTER}" \
    '.assets | sort_by(.created_at) | reverse | .[] | select(.name|test($asset_filter)) | select (.name|test("rpm$")) | .browser_download_url'))

if [ "${#RPM_URLS[@]}" -eq 0 ]; then
  echo "no rpm assets were found"
  exit 4
fi

# WARNING: in case of multiple matches, this only downloads/installs the first matched release
if [ ! -z ${DOWNLOAD_ONLY+x} ]; then
  download_args=(
    '--fail'
    '--retry' '5'
    '--retry-delay' '5'
    '--retry-all-errors'
    '-sL'
    '--output-dir' "${OUTPUT_DIR}"
    '--create-dirs'
  )

  if [ -z "${OUTPUT_FILE+x}" ]; then
    download_args+=( '-O' )
  else
    download_args+=( '-o' "${OUTPUT_FILE}" )
  fi

  curl ${download_args[@]} "${RPM_URLS}"
else
  echo "execute: rpm-ostree install \"${RPM_URLS}\""
  rpm-ostree install "${RPM_URLS}";
fi
