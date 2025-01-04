{
  inputs,
  pkgs,
  lib,
  ...
}: let
  flake = "/home/dan/sys";
in {
  #-----------------------------------------------------------------------------
  # NIX

  # Got this from https://www.youtube.com/watch?v=M_zMoHlbZBY
  # TODO: Document why this is needed.
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  nix.settings = {
    experimental-features = "nix-command flakes";

    # Avoid building Hyprland from source.
    # See https://wiki.hyprland.org/Nix/Cachix/.
    # TODO: Figure out of this actually does anything... Not sure it does.
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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

  environment.variables = {
    # Without this, Electron apps won't run in `niri`.
    NIXOS_OZONE_WL = "1";
  };

  environment.sessionVariables = {
    FLAKE = flake;
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

    dbus.enable = true;

    gnome.gnome-keyring.enable = true;
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

  environment.systemPackages = let
    script = pkgs.writeScriptBin;
    bashScript = pkgs.writeShellScriptBin;
  in
    with pkgs; [
      # SCRIPTS

      (script "os" (builtins.readFile ./scripts/os.nu))
      (bashScript "oss" ''os switch'')

      (bashScript "vol-inc" ''wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+'')
      (bashScript "vol-dec" ''wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-'')
      (bashScript "vol-mute" ''wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'')
      (bashScript "mic-mute" ''pactl set-source-mute @DEFAULT_SOURCE@ toggle'')

      (bashScript "br-inc" ''brightnessctl set 10%+'')
      (bashScript "br-dec" ''brightnessctl set 10%-'')

      # CLI

      nh
      nushell
      zoxide
      carapace
      fd
      ripgrep
      yazi
      micro
      bat
      tealdeer
      wget
      curl
      rsync
      unar
      yt-dlp
      git
      dijo
      alejandra
      pciutils
      buku
      taskwarrior3
      taskwarrior-tui
      taskopen
      nixd

      # HARDWARE

      brightnessctl
      openrazer-daemon
      networkmanagerapplet
      pavucontrol

      # GUI

      xwayland
      xwayland-satellite
      xdg-utils
      wev
      waybar
      mako
      libnotify
      hyprpaper
      kitty
      firefox-wayland
      qutebrowser
      vscode.fhs
      emacs
      tofi
      rofi-wayland
      fuzzel
      tauon
      papirus-icon-theme
      nautilus
      ulauncher
    ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    iosevka
    iosevka-comfy.comfy
    roboto
    roboto-slab
    roboto-mono
    cantarell-fonts
    font-awesome

    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    dconf.enable = true;
  };
}
