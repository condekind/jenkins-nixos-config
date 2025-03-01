#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/condekind/jenkins-nixos-config.git"
TARGET_DIR="/etc/nixos"
TEMP_DIR="$(mktemp -d)"
VERSION=v0.0.1

echo "Bootstrapping Jenkins on NixOS configuration..."

if ! command -v git &> /dev/null; then
    echo "Installing git temporarily using nix-shell..."
    echo "Cloning configuration repository..."
    nix-shell -p git --run "git clone --branch="$VERSION" \"$REPO_URL\" \"$TEMP_DIR\""
else
    git clone --branch="$VERSION" "$REPO_URL" "$TEMP_DIR"
fi

if [[ -f "$TARGET_DIR/configuration.nix" ]]; then
    echo "Backing up existing configuration..."
    cp "$TARGET_DIR/configuration.nix" "$TARGET_DIR/configuration.nix.backup.$(date --utc +%Y%m%dT%H%M%S)"
fi

echo "Copying configuration files to $TARGET_DIR..."
cp "$TEMP_DIR"/etc/nixos/*.nix "$TARGET_DIR/"

echo "Setting permissions..."
chmod 644 "$TARGET_DIR"/*.nix

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Rebuilding NixOS configuration..."
nixos-rebuild switch

echo "Bootstrap complete! Jenkins should now be installed and running."
echo "You can access the Jenkins web interface at http://<YOUR_EC2_IP>:8080"
echo "Initial admin password can be found with: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

printf '\n\nCongrats!\nHowever, this script is far from fully automated.\n\x1b[37;41mYou still have pending chores:\x1b[0m\n';
grep -nR "TODO(you)" etc/nixos | tr -s ' ' ' '