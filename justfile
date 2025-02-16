# List recipes
default:
    @just --list --unsorted

# Build and install (activate) the new system
[group('System')]
in:
    nh os switch

# Build and test the new system
[group('System')]
test:
    nh os test

# Build the new system without activating it
[group('System')]
build:
    nh os build

# Collect garbage (delete old revisions)
[group('System')]
gc:
    nh os clean all

# Update flake inputs
[group('Flake')]
up:
    nix flake update

# Check that the flake is not broken
[group('Flake')]
check:
    nix flake check

# Enter a Nix REPL with the flake loaded
[group('Flake')]
repl:
    nh os repl
