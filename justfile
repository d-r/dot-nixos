# List recipes
default:
    @just --list --unsorted

# Build and install (activate) the new system
[group('System')]
in:
    sudo nixos-rebuild --flake . switch

# Build and test the new system
[group('System')]
test:
    sudo nixos-rebuild --flake . test

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
