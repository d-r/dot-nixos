{
  config,
  pkgs,
  ...
}: let
  dots = config.lib.file.mkOutOfStoreSymlink "/home/dan/sys/dots";
  defaultFont = {
    name = "JetBrains Mono";
    # A size of 10pt should equate to 13px, which is the size that JetBrains
    # recommends for the font.
    size = 10;
  };
in {
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  home.packages = with pkgs; [
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
  ];

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    # Not sure...
    # createDirectories = true;
  };

  xdg.configFile = {
    "hypr/settings.conf".source = "${dots}/hypr/hyprland.conf";
    "hypr/hyprpaper.conf".source = "${dots}/hypr/hyprpaper.conf";
    "waybar".source = "${dots}/waybar";
    "niri".source = "${dots}/niri";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = builtins.readFile ./dots/hypr/hyprland.conf;
    plugins = [pkgs.hyprlandPlugins.hyprscroller];
    extraConfig = "source = settings.conf";
  };

  programs.bash.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
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

  # To generate a new SSH key for GitHub:
  # ssh-keygen -t ed25519 -C "9402+d-r@users.noreply.github.com"
  programs.git = {
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
      pf = "push --force";
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
      confirm_os_window_close = "0";
      enable_audio_bell = false;
      allow_remote_control = "socket-only";
    };
  };

  programs.qutebrowser = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
