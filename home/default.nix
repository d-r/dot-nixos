{
  config,
  pkgs,
  ...
}: let
  dan = "/home/dan";
  dots = config.lib.file.mkOutOfStoreSymlink "${dan}/sys/home";
in {
  imports = [
    ./shell.nix
    ./tealdeer.nix
    ./task.nix
    ./git.nix
    ./kitty.nix
  ];

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
}
