#!/bin/bash

set -oeux pipefail

# Alternatives cannot create symlinks on its own during a container build
ln -sf /usr/bin/step-cli /etc/alternatives/step && ln -sf /etc/alternatives/step /usr/bin/step

ln -sf /usr/lib/gcm/git-credential-manager /usr/bin/git-credential-manager

# rbw completions must be manually generated (tar: completion: Cannot change mode to rwxr-xr-x: Operation not permitted)
/usr/bin/rbw gen-completions bash > /usr/share/bash-completion/completions/rbw
/usr/bin/rbw gen-completions zsh > /usr/share/zsh/site-functions/_rbw

# Step CLI RPM does not create zsh completions
/usr/bin/step-cli completion zsh > /usr/share/zsh/site-functions/_step
