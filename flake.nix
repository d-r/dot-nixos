{
  description = "Dan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "github:hyprwm/Hyprland";

    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations.pad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./host.nix
        ./os.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dan = import ./home.nix;
        }
        # hyprland.homeManagerModules.default
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
