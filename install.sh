# Install extras fonts
# MesloLGS NF (used for p10k)
mkdir -p /usr/share/fonts/meslolgs-nf
curl --output-dir /usr/share/fonts/meslolgs-nf -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl --output-dir /usr/share/fonts/meslolgs-nf -LO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache --system-only --really-force --verbose

# Setup packages
/tmp/packages.sh /tmp/packages.json

# Install packages directly from GitHub
/tmp/github-release-install.sh smallstep/cli amd64

# Install rbw
# https://github.com/doy/rbw
mkdir /tmp/rbw
curl -Lo /tmp/rbw/rbw_linux_amd64.tar.gz https://github.com/doy/rbw/releases/download/1.9.0/rbw_1.9.0_linux_amd64.tar.gz
tar -C /tmp/rbw -xf /tmp/rbw/rbw_linux_amd64.tar.gz
cp /tmp/rbw/rbw /tmp/rbw/rbw-agent /usr/bin
cp /tmp/rbw/completion/bash /usr/share/bash-completion/completions/rbw
cp /tmp/rbw/completion/zsh /usr/share/zsh/site-functions/_rbw