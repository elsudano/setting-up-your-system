#!/bin/bash

umask 0022
echo "$(whoami) ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami) > /dev/null
OS=$(hostnamectl | grep "Operating System:" | awk -F\  '{ print $3 }')

if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -b 4096 -t rsa
    cat ~/.ssh/id_rsa.pub | tee -a ~/.ssh/authorized_keys > /dev/null
fi
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -a 100 -b 4096
    cat ~/.ssh/id_ed25519.pub | tee -a ~/.ssh/authorized_keys > /dev/null
fi
if [ "$OS" = "Ubuntu" ]; then
    sudo apt update && sudo apt -y install nano git make python3-virtualenv ansible openssh-server
    sudo update-alternatives --set editor $(which nano)
    echo -e "PubkeyAuthentication yes\nX11Forwarding no" | sudo tee /etc/ssh/sshd_config.d/90_permit_ssh_key_authentication.conf > /dev/null
    sudo systemctl reload ssh && sudo systemctl enable ssh && sudo systemctl stop ssh && sudo systemctl start ssh
fi
if [ "$OS" = "RedHat" ] || [ "$OS" = "Centos" ] || [ "$OS" = "AlmaLinux" ]; then
    sudo dnf update && sudo dnf -y install nano git make python3-virtualenv ansible
fi
if [ "$OS" = "Suse" ]; then
    sudo zypper install ansible nano make python3-virtualenv
    sudo ln -s $(which python3.6) /usr/bin/python
fi
if [ "$OS" = "Archlinux" ] || [ "$OS" = "Manjaro" ]; then
    sudo pacman -Syu
    sudo pacman -Sy yay ansible git make python 
fi
