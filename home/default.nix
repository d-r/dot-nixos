{
  config,
  pkgs,
  inputs,
  ...
}: let
  dan = "/home/dan";
  dots = config.lib.file.mkOutOfStoreSymlink "${dan}/dot/home";
  shellAliases = {
    os = "nh os";
    oss = "os switch";

    ni = "niri msg";
    hc = "hyprctl";

    c = "clear";
    e = "micro";
    j = "just";
    t = "task";
    yt = "yt-dlp";

    g = "git";
    gs = "git st";
    gd = "git diff";
    gl = "git log";
    gc = "git clone";
  };
in {
  home.stateVersion = "24.05";
  home.username = "dan";
  home.homeDirectory = dan;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    download = "$HOME/dl";
    documents = "$HOME/docs";
    pictures = "$HOME/images";
    music = "$HOME/audio";
  };

  xdg.configFile = {
    "git".source = "${dots}/git";
    "kitty".source = "${dots}/kitty";
    "task".source = "${dots}/task";
    "tealdeer".source = "${dots}/tealdeer";
    "nvim".source = "${dots}/nvim";
    "nushell/dan.nu".source = "${dots}/nushell/config.nu";
    "emacs/early-init.el".source = "${dots}/emacs/early-init.el";
    "emacs/init.el".source = "${dots}/emacs/init.el";
    "waybar".source = "${dots}/waybar";
    "niri".source = "${dots}/niri";
    "hypr/dan.conf".source = "${dots}/hypr/hyprland.conf";
  };

  home.sessionPath = [
    "$HOME/dot/bin"
  ];

  home.shellAliases = shellAliases;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    localVariables = {
      PROMPT = "%F{blue}%~> ";
    };
  };

  programs.nushell = {
    enable = true;
    shellAliases = shellAliases;
    configFile.text = ''source dan.nu'';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  services.mako = {
    enable = true;
    defaultTimeout = 5000; # 5 seconds in milliseconds.
    backgroundColor = "#000000ff";
    borderColor = "#595959aa";
    width = 600;
    height = 9000; # No height limit. Default is 100.
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Use the packages from the NixOS module.
    portalPackage = null;
    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
    ];
    extraConfig = "source = dan.conf";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    hyprcursor = {
      enable = true;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };
}
