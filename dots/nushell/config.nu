$env.config.show_banner = false

alias c = clear
alias d = dijo
alias e = ^($env.EDITOR)
alias j = just
alias t = task
alias topen = taskopen
alias gc = git clone
alias yt = yt-dlp

def l [...xs] {
    let xs = if $xs == [] { ["."] } else { $xs }
    ls -al ...$xs | sort-by type
}
