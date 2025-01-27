{pkgs, ...}: {
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
}
