# Jenkins on NixOS (EC2 edition)

This repo holds some initial configurations to have Jenkins running in a NixOS system.

## Usage

1. Launch an EC2 image with an [official](https://nixos.github.io/amis/) NixOS AMI

2. SSH into the container, then run:

```bash
# Check the existing branches of this project to select a version
# Once we're somwhat stable, there will be a 'latest' branch
VERSION=v0.0.1;

curl -sSL "https://raw.githubusercontent.com/condekind/jenkins-nixos-config/refs/heads/${VERSION}/bootstrap.bash" | bash
```

## TODOs

- Terraform to automate instance launch
- Ansible
