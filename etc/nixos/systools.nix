{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ngrok
    tcpdump
    ldns
    dnsutils
    netcat
    iputils
    traceroute
    whois
    mtr
    inetutils
    htop
    less
    findutils
    gawk
    gnused
  ];
}