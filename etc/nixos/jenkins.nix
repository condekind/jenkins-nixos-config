{ config, pkgs, ... }:

{
  # Create jenkins user
  users.users.jenkins = {
    isSystemUser = true;
    description = "Jenkins automation server";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    # TODO(you): Add ssh keys
    openssh.authorizedKeys.keys = [ ];
  };

  users.groups.jenkins = {};

  # Enable Jenkins service
  services.jenkins = {
    enable = true;
    package = pkgs.jenkins;
    port = 8080;
    user = "jenkins";
    extraGroups = [ "docker" ];
    environment = {
      JENKINS_HOME = "/var/lib/jenkins";
    };
    # TODO(you): restrict IP range
    extraOptions = [
      "--httpListenAddress=0.0.0.0"
    ];
  };

  # Docker for container builds in Jenkins
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  # Ensure Jenkins can use Docker
  users.groups.docker.members = [ "jenkins" ];

  # TODO(you): configure HTTPS/web UI
  # services.nginx = {
  #   enable = true;
  #   virtualHosts."jenkins.example.com" = {
  #     locations."/" = {
  #       proxyPass = "http://127.0.0.1:8080";
  #       proxyWebsockets = true;
  #     };
  #   };
  # };
}