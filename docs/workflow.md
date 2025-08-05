1. bootstrap env
    - fresh arch install
    - snapper configured
    - clone config to /opt/system-config
    - install dev tools: git, make, nvim

2. dev loop
    - snapshot-baseline
    - test-graphics
    - breaks; rollback
    - works; snapshot-ok, git commit

3. config categories
    - critical systems: networking, bootloader, users
    - hardware drivers: graphics, audio, input, bluetooth, etc.
    - desktop env: wm, display manager
    - applications: terminal, browser, dev tools
    - dot files: shell, editor, themes

# git integration
- main branch: known working
- feature branch: each config category (graphics, audio, etc.)
- hardware branches: device specific tweaks

    ## start new config
    git checkout -b config/graphics
    make snapshot-baseline
    ./install-graphics.sh  # iterate until working, test, rollback, repeat

    ## once working
    make test-full-system
    git add . && git commit -m "graphics: working nividia setup"
    git checkout main && git merge config/graphics

# add'l tools
- chroot for package/config dev
- snapshots for hardware validation
