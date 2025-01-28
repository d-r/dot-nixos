#!/usr/bin/env nu

# Build and activate the new configuration
def "main switch" [] {
    sudo nixos-rebuild --flake ~/dot switch
}

# Build and test the new configuration
def "main test" [] {
    sudo nixos-rebuild --flake ~/dot test
}

# Update Flake inputs
def "main pull" [] {
    nix flake update --flake ~/dot
}

# Collect garbage (remove old revisions)
def "main gc" [] {
    sudo nix-collect-garbage -d
}

def main [] {}
