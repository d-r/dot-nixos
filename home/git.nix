{pkgs, ...}: {
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
}
