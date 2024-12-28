{ config, pkgs, ... }:
let
  dots = config.lib.file.mkOutOfStoreSymlink "/home/dan/sys/dots";

  defaultFont = {
      name = "JetBrains Mono";
      # A size of 10pt should equate to 13px, which is the size that JetBrains
      # recommends for the font.
      size = 10;
  };
in
{
  home = {
    username = "dan";
    homeDirectory = "/home/dan";

    packages = with pkgs; [
      nushell
      bat
      dijo
      yt-dlp
      unar

      google-chrome

      obsidian

      # IDEs
      jetbrains-toolbox
      # jetbrains.rust-rover
      # jetbrains.clion
      # jetbrains.webstorm
      # jetbrains.pycharm-professional

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    sessionVariables = {
      DEFAULT_BROWSER = "chrome";
      # EDITOR = "emacs";
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      # Not sure...
      # createDirectories = true;
    };

    # mimeApps = {
    #   enable = true;
    #   defaultApplications = {
    #     "text/html" = "firefox";
    #     "x-scheme-handler/http" = "firefox";
    #     "x-scheme-handler/https" = "firefox";
    #     "application/pdf" = "firefox";
    #   };
    # };

    configFile = {
      # "hypr".source = "${dots}/hypr";
      "hypr/dan.conf".source = "${dots}/hypr/hyprland.conf";
      "waybar".source = "${dots}/waybar";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = builtins.readFile ./dots/hypr/hyprland.conf;
    plugins = [ pkgs.hyprlandPlugins.hyprscroller ];
    extraConfig = "source = dan.conf";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # To generate a new SSH key for GitHub:
    # ssh-keygen -t ed25519 -C "9402+d-r@users.noreply.github.com"
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Daniel Rosengren";
      userEmail = "9402+d-r@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
      aliases = {
        st = "status --short";
        lg = "log --oneline --decorate";
        lf = "log --name-status";
        last = "log -1 HEAD --stat";

        co = "checkout";
        new-branch = "checkout -b";
        delete-branch = "branch -D";
        delete-remote-branch = "push origin --delete";
        rename-branch = "branch -m";
        move-branch = "branch -f";

        ca = "commit -a --amend --no-edit";
        amend = "commit --amend";
        discard = "checkout --";
        unstage = "reset head --";
        untrack = "rm -r --cached";
        nevermind = "!git reset --hard HEAD && git clean -d -f";
        nm = "nevermind";
        undo = "reset --hard HEAD~";

        branches = "branch -a -v";
        tags = "tag list";
        stashes = "stash list";
        remotes = "remote -v";
      };
    };

    kitty = {
      enable = true;
      themeFile = "VSCode_Dark";
      font = defaultFont;
      settings = {
        confirm_os_window_close = "0";
        enable_audio_bell = false;
        allow_remote_control = "socket-only";
      };
    };

    qutebrowser = {
      enable = true;
    };
  };

  home.stateVersion = "24.05";
}
