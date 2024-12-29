{ inputs, lib, config, pkgs, modulesPath, ... }:
let
  osScript = pkgs.writeShellScriptBin "os" ''
    sudo nixos-rebuild --flake ~/sys#pad $@
  '';
  ossScript = pkgs.writeShellScriptBin "oss" ''
    os switch
  '';
in
{
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

  users.users.dan = {
    isNormalUser = true;
    initialPassword = "iamdan";
    extraGroups = [
      "wheel"
      "networkemanager"
    ];
  };

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

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    openssh.enable = true;
 
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    dbus.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs = {
    xwayland.enable = true;

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    # Utility for changing screen brightness.
    #
    # Decrease brightness by 30%:
    #   $ light -U 30
    #
    # Increase brightness by 30%:
    #   $ light -A 30
    light.enable = true;

    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Scripts
    osScript
    ossScript

    # Nix Helper
    nh

    # CLI basics
    git
    wget
    curl
    rsync
    micro
    tealdeer

    # Nix language tools
    # See https://www.youtube.com/watch?v=M_zMoHlbZBY
    nixd
    alejandra

    # GUI basics
    wayland
    kitty
    alacritty
    firefox-wayland
    vscode.fhs

    # Top bar for WM
    waybar

    # Wallpaper utility for Hyprland
    hyprpaper

    # Notification daemon
    mako

    # Provides `notify-send` command to send desktop notifications
    libnotify

    # Provides `lscpi` command to query builtin devices
    pciutils

    # Support for my Razer mouse
    openrazer-daemon razergenie

    # WIFI widget
    networkmanagerapplet

    # Audio control panel
    pavucontrol

    # App launchers
    tofi
    fuzzel

    # Wayland Event Viewer
    #
    # Useful when defining keybinds and you need to work out what a certain key
    # is called. For example, this is how I discovered that the volume keys are
    # named "XF86AudioLowerVolume" and XF86AudioRaiseVolume".
    wev

    xdg-utils
  ];

  environment.variables = {
    # Without this, Electron apps won't run in `niri`.
    NIXOS_OZONE_WL = "1";
  };

  environment.sessionVariables = {
    FLAKE = "/home/dan/sys";
    EDITOR = "micro";
    TERMINAL = "kitty";
    DEFAULT_BROWSER = "firefox";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono

    iosevka
    iosevka-comfy.comfy

    roboto
    roboto-slab
    roboto-mono  
  ];

  system.stateVersion = "24.05";
}
