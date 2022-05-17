#!/bin/sh
set -o errexit -o nounset

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPOS_DIR="$(mktemp -d -t macos_setup_repos)"

trap 'rm -rf "$REPOS_DIR"' EXIT
(
    echo "Installing PAM Touch ID..."
    cd "$REPOS_DIR"
    set -x
    git clone https://github.com/Reflejo/pam-touchID.git
    cd pam-touchID
    sudo make install
    set +x

    cd -
    echo "Installing PAM Watch ID..."
    set -x
    git clone https://github.com/biscuitehh/pam-watchid.git
    cd pam-watchid
    sudo make install
    set +x
)

echo "Updating Dock..."

set -x
dockutil --remove all --no-restart
dockutil --add /Applications/Orion.app --no-restart
dockutil --add /Applications/Safari.app --no-restart
dockutil --add ~/Downloads --display stack # Implicitly restarts the Dock.
set +x


echo "Resetting QuickLook."
set -x
qlmanage -r
qlmanage -r cache
killall Finder
set +x

echo "Disabling Homebrew analytics."
set -x
brew analytics off
set +x

echo "Disabling netbiosd."
set -x
sudo launchctl disable system/netbiosd
sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.netbiosd.plist 2>/dev/null
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.netbiosd.plist 2>/dev/null
set +x
