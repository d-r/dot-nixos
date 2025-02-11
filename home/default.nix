{
  config,
  pkgs,
  ...
}: let
  dan = "/home/dan";
  dots = config.lib.file.mkOutOfStoreSymlink "${dan}/dot/home";
  defaultFont = {
    name = "JetBrains Mono";
    # A size of 10pt should equate to 13px, which is the size that JetBrains
    # recommends for the font.
    size = 10;
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
    "emacs/early-init.el".source = "${dots}/emacs/early-init.el";
    "emacs/init.el".source = "${dots}/emacs/init.el";
    "waybar".source = "${dots}/waybar";
    "niri".source = "${dots}/niri";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.nushell = {
    enable = true;
    envFile.source = ./nushell/env.nu;
    configFile.source = ./nushell/config.nu;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--long"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        use_pager = true;
      };
      updates = {
        auto_update = true;
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

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Daniel Rosengren";
    userEmail = "9402+d-r@users.noreply.github.com";
    ignores = [
      # macOS Finder detritus
      ".DS_Store"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      # Removes the need to do "git push --set-upstream origin <branch>" for
      # a branch that doesn't yet exist upstream.
      push.autoSetupRemote = true;
    };
    aliases = {
      st = "status --short";
      lg = "log --oneline --decorate";
      lf = "log --name-status";
      last = "log -1 HEAD --stat";

      co = "checkout";
      pf = "push --force";

      nb = "new-branch";
      db = "delete-branch";
      drb = "delete-remote-branch";
      rb = "rename-branch";
      mv = "move-branch";

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

  programs.kitty = {
    enable = true;
    themeFile = "VSCode_Dark";
    font = defaultFont;
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      confirm_os_window_close = "0";
      enable_audio_bell = false;
      allow_remote_control = "socket-only";
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

  # TODO: Tweak appearance.
  # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mako.enable
  services.mako = {
    enable = true;
    # 5 seconds in milliseconds.
    defaultTimeout = 5000;
  };
}
