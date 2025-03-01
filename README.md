# Jenkins on NixOS (EC2 edition)

This repo holds some initial configurations to have Jenkins running in a NixOS system.

## Usage

1. Launch an EC2 image with an [official](https://nixos.github.io/amis/) NixOS AMI

2. SSH into the container, then run:

```bash
curl -sSL https://raw.githubusercontent.com/condekind/jenkins-nixos-config/refs/heads/v0.0.1/bootstrap.bash | bash
```

## TODOs

- Terraform to automate instance launch
- Ansible