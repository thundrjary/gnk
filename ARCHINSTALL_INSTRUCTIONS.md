## ARCHINSTALL INSTRUCTIONS

#### set up wifi
```
> iwctl adapter phy0 set-property Powered on
> iwctl station wlan0 scan
> iwctl station wlan0 connect <ssid>
> ping -c 2 google.com
```

### start install
`> archinstall`

#### partitioning
- bkrfs

#### packages
- git
- sudo
- neovim
