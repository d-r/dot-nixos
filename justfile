set shell := ["nu", "-c"]

default:
    @just --list

# Build and install the new system
in:
    sudo nixos-rebuild --flake . switch

# Build and test the new system
test:
    sudo nixos-rebuild --flake . test

# Update flake inputs
up:
    nix flake update

# Collect garbage (delete old OS revisions)
gc:
    sudo nix-collect-garbage -d
