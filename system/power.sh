#!/bin/bash

yay -S --noconfirm --needed \
    tlp \
    tlp-rdw \
    acpi_call \
    brightnessctl

sudo systemctl enable tlp
