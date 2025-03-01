{ config, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./jenkins.nix
    ./development-tools.nix
    ./system-tools.nix
    ./editors.nix
    ./shells.nix
  ];

  # Set time zone and keyboard layout
  time.timeZone = "UTC";
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "intl";
  console.keyMap = "us-acentos";

  # Enable networking
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8080 ]; # SSH and Jenkins
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Basic system packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
  ];

  # System-wide configuration
  system.stateVersion = "24.11";
}