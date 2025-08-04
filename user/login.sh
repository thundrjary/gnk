#!/usr/bin/env bash

yay -S --noconfirm --needed greetd wlgreet

sudo cp config/greetd/config.toml /etc/greetd/config.toml
sudo systemctl enable greetd
