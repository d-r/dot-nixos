{ lib, config, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./os.nix
  ];

  system.stateVersion = "24.05";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

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

    graphics = {
      enable = true;
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

  networking.hostName = "pad";
}
