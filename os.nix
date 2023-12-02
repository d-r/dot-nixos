{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";

    # Avoid building Hyprland from source.
    # See https://wiki.hyprland.org/Nix/Cachix/.
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  boot = {
    # Use latest kernel. Need this for WIFI to work.
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = [ 
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [amdvlk];
    };

    # Disable PulseAudio as it conflicts with PipeWire.
    pulseaudio.enable = false;

    openrazer.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };
  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  networking = {
    hostName = "pad";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services = {
    openssh.enable = true;
 
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # GNOME
    # xserver = {
    #   enable = true;
    #   displayManager.gdm.enable = true;
    #   desktopManager.gnome.enable = true;
    # };

    dbus.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    # The Hyprland window manager.
    # I'm using the development version provided as a flake.
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
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

  environment = {
    systemPackages = with pkgs; [
      # CLI basics
      git
      wget
      curl
      rsync
      micro
      tealdeer

      # GUI basics
      wayland
      kitty
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

      # App launcher
      tofi

      # Wayland Event Viewer
      #
      # Useful when defining keybinds and you need to work out what a certain key
      # is called. For example, this is how I discovered that the volume keys are
      # named "XF86AudioLowerVolume" and XF86AudioRaiseVolume".
      wev

      xdg-utils
    ];

    sessionVariables = {
      EDITOR = "micro";
      TERMINAL = "kitty";
      DEFAULT_BROWSER = "firefox";
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono

    iosevka
    iosevka-comfy.comfy

    roboto
    roboto-slab
    roboto-mono  
  ];

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
  
  users.users.dan = {
    isNormalUser = true;
    initialPassword = "iamdan";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  system.stateVersion = "24.05";
}
