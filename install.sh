#!/bin/bash

# NOTE: this is only for devcontainer's dotfiles.installCommand along with
# "ghcr.io/devcontainers-extra/features/ansible:2": {} feature

ansible-playbook ansible/playbook.yaml --tags for_devcontainer
