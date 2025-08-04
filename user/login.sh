#!/usr/bin/env bash

yay -S --noconfirm --needed greetd wlgreet

sudo cp config/greetd/config.toml /etc/greetd/config.toml
sudo cp config/greetd/wlgreet.toml /etc/greetd/wlgreet.toml
sudo systemctl enable greetd
