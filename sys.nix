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
    DEFAULT_BROWSER = "firefox";
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

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Supposed to enable some kind of build cache for Hyprland, when using the
  # flake version. No idea if it actually works or not. Doesn't seem to.
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
    # CLI

    nushell
    zoxide
    fd
    ripgrep
    yazi
    micro
    neovim
    bat
    tealdeer
    wget
    curl
    rsync
    unar
    yt-dlp
    taskwarrior3
    taskwarrior-tui
    neofetch

    # WM

    xdg-utils
    xwayland
    xwayland-satellite
    wl-clipboard
    clipse
    waybar
    mako
    libnotify
    swaybg
    pavucontrol
    brightnessctl
    networkmanagerapplet
    rofi-wayland
    wev

    # GUI

    kitty
    wezterm
    firefox-wayland
    brave
    qutebrowser
    vscode.fhs
    emacs
    tauon
    nautilus

    # DEV

    git
    just
    nixd
    alejandra
    rustup
    lua
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

  # Disabled because it conflicts with Hyprland.
  # TODO: Figure out how to have them both co-exist. If I can be bothered.
  programs.niri = {
    enable = false;
    package = pkgs.niri-unstable;
  };

  # This needs to be enabled here, even when you're also enabling Hyprland in
  # the Home Manager config.
  programs.hyprland = {
    enable = true;
    # Use the flake packages.
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.dconf.enable = true;
}
