$env.config.show_banner = false

$env.PROMPT_COMMAND_RIGHT = ""

# Wrapper around yazi that provides the ability to change the current working
# directory on exit.
# Source: https://yazi-rs.github.io/docs/quick-start#shell-wrapper
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

