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
    "wezterm".source = "${dots}/wezterm";
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

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        use_pager = true;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
    };
  };

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    dataLocation = "$XDG_DATA_HOME/task";
    config = {
      # 1-nov-24"
      dateFormat = "d-b-y";
      # Don't nag me about news
      news.version = "3.9.9";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "VSCode_Dark";
    font = {
      name = "JetBrains Mono";
      size = 10; # Points, not pixels
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";

      confirm_os_window_close = "0";
      enable_audio_bell = false;
      allow_remote_control = "socket-only";
      copy_on_select = true;

      disable_ligatures = "always";
      window_padding_width = "8";
      tab_bar_edge = "top";
      active_tab_font_style = "normal"; # Default is "italic"
    };
    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+w" = "close_tab";
      "ctrl+page_up" = "previous_tab";
      "ctrl+page_down" = "next_tab";
      "ctrl+shift+page_up" = "move_tab_backward";
      "ctrl+shift+page_down" = "move_tab_forward";
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      link-url = true;
      font-feature = "-calt"; # Disable ligatures
      window-padding-x = 8;
      window-padding-y = 8;
    };
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
