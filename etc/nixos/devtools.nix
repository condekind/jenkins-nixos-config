{ config, pkgs, ... }:

{
  # Development tools
  environment.systemPackages = with pkgs; [
    gnumake
    cmake
    ninja
    gnupg
    parallel
    python313
    python313Packages.pip
    rustup
    ripgrep
  ];

  # For yarn and Node.js via nvm
  environment.shellInit = ''
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  '';

  # Install nvm and Node.js LTS
  system.activationScripts.nodeSetup = {
    deps = [];
    text = ''
      # Install nvm for root if not already installed
      if [ ! -d "/root/.nvm" ]; then
        echo "Installing nvm for root user..."
        ${pkgs.curl}/bin/curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="/root/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts v16
        nvm install --lts v18
        nvm install --lts v20
        nvm install --lts v22 --latest-npm
        nvm alias default lts/v22
        npm install -g yarn
      fi

      # Install nvm for jenkins user if not already installed
      if [ ! -d "/var/lib/jenkins/.nvm" ]; then
        echo "Installing nvm for jenkins user..."
        mkdir -p /var/lib/jenkins/.nvm
        chown jenkins:jenkins /var/lib/jenkins/.nvm
        su - jenkins -c '${pkgs.curl}/bin/curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
        su - jenkins -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts v22 --latest-npm && nvm alias default lts/v22 && npm install -g yarn'
      fi
    '';
  };
}