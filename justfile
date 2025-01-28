set shell := ["nu", "-c"]

# List recipes
default:
    @just --list --unsorted

# Build and install (activate) the new system
[group('System')]
in:
    sudo nixos-rebuild --flake . switch
    source $nu.config-path

# Build and test the new system
[group('System')]
test:
    sudo nixos-rebuild --flake . test
    source $nu.config-path

# Build the new system without activating it
[group('System')]
build:
    sudo nixos-rebuild --flake . build

# Collect garbage (delete old revisions)
[group('System')]
gc:
    sudo nix-collect-garbage -d

# Update flake inputs
[group('Flake')]
up:
    nix flake update

# Check that the flake is not broken
[group('Flake')]
check:
    nix flake check
