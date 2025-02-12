$env.config.show_banner = false

alias c = clear
alias d = dijo
alias e = ^($env.EDITOR)
alias j = just
alias t = task
alias yt = yt-dlp

alias g = git;
alias gs = git st
alias gd = git diff
alias gc = git clone

def l [...xs] {
    let xs = if $xs == [] { ["."] } else { $xs }
    ls -al ...$xs | sort-by type
}
