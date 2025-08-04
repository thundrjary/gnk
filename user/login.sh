#!/usr/bin/env bash

yay -S --noconfirm --needed greetd greetd-tuigreet

sudo cp config/greetd/config.toml /etc/greetd/config.toml
