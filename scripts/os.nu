#!/usr/bin/env nu

# Build and activate the new configuration
def "main switch" [] {
    sudo nixos-rebuild --flake ~/sys#pad switch
}

# Build and test the new configuration
def "main test" [] {
    sudo nixos-rebuild --flake ~/sys#pad test
}

# Update Flake inputs
def "main pull" [] {
    nix flake update --flake ~/sys
}

# Collect garbage (remove old revisions)
def "main gc" [] {
    sudo nix-collect-garbage -d
}

def main [] {}
