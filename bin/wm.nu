#!/usr/bin/env nu

export def main [] {}

export def "main focused-workspace" [] {
    hc activeworkspace
}

export def "main focused-window" [] {
    hc activewindow
}

export def "main monitors" [] {
    hc monitors
}

export def "main workspaces" [] {
    hc workspaces
}

export def "main windows" [] {
    hc clients
}

export def "main invoke" [dispatcher: string, ...args] {
    hc dispatch $dispatcher ...$args
}

def hc [...args] {
    hyprctl ...$args -j | from json
}
