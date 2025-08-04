#!/bin/bash
clear
read -p "Username: " user
read -s -p "Password: " pass
echo

if echo "$pass" | su -c "true" "$user" >/dev/null 2>&1; then
  exec sudo -u "$user" Hyprland
else
  echo "Login failed"
  read -p "Retry? Press Enter"
  exec "$0"
fi
