{
  inputs,
  pkgs,
  lib,
  ...
}: {
  nix.settings.experimental-features = "nix-command flakes";

  #-----------------------------------------------------------------------------
  # USERS

  users.users.dan = {
    isNormalUser = true;
    initialPassword = "iamdan";
    extraGroups = [
      "wheel"
      "networkemanager"
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  #-----------------------------------------------------------------------------
  # ENVIRONMENT

  i18n = {
    defaultLocale = "en_IE.UTF-8";
    supportedLocales = [
      "en_IE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
      "sv_SE/ISO-8859-1"
    ];
  };

  time.timeZone = "Europe/Stockholm";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Without this, Electron apps won't run in `niri`.
    EDITOR = "micro";
    TERMINAL = "kitty";
    DEFAULT_BROWSER = "brave";
  };

  #-----------------------------------------------------------------------------
  # SERVICES

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # Enable the RealtimeKit system service.
  # This hands out realtime scheduling priority to user processes on demand.
  # The PulseAudio server uses this to acquire realtime priority.
  security.rtkit.enable = true;

  services = {
    openssh.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Disable PulseAudio as it conflicts with PipeWire.
    # TODO: Verify that this is actually needed.
    pulseaudio.enable = false;

    dbus.enable = true;

    gnome.gnome-keyring.enable = true;

    emacs.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  #-----------------------------------------------------------------------------
  # PACKAGES

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    # Needed for Logseq
    "electron-27.3.11"
  ];

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Enable some kind of build cache for the flake version Hyprland.
  # https://wiki.hyprland.org/Nix/Cachix/
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  environment.systemPackages = with pkgs; [
    # BEING EVALUATED

    zk
    fzf
    skim
    carapace
    mako
    emacs
    neovim
    brave
    qutebrowser
    nautilus
    tauon

    # Provides `wl-copy` and `wl-paste` commands
    # https://github.com/bugaevc/wl-clipboard
    wl-clipboard

    # TUI clipboard manager
    # https://github.com/savedra1/clipse
    clipse

    wezterm

    # CLI

    nushell
    zoxide
    ripgrep
    fd
    yazi
    micro
    bat
    tealdeer
    wget
    curl
    rsync
    unar
    unzip
    yt-dlp
    taskwarrior3
    taskwarrior-tui
    neofetch

    # WM

    xdg-utils
    xwayland-satellite
    libnotify
    swaybg
    pavucontrol
    brightnessctl
    networkmanagerapplet
    rofi-wayland
    waybar
    wev

    # GUI

    kitty
    firefox-wayland
    vscode.fhs
    logseq

    # DEV

    git
    gcc
    gnumake
    cmake
    just
    nixd
    alejandra
    rustup
    lua
    luarocks
    luajit
    fennel
    jetbrains.rust-rover
    jetbrains.clion
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    iosevka
    iosevka-comfy.comfy
    roboto
    roboto-slab
    roboto-mono
    cantarell-fonts
    terminus_font_ttf
    terminus_font
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/dan/dot";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # Hyprland enables xwayland. niri disables it.
  # Enabling it here, or I get an error about conflicting values.
  # Hoping this doesn't cause any weirdness when running niri.
  programs.xwayland.enable = true;

  programs.dconf.enable = true;
}
