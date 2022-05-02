{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url =
    #   "github:nixos/nixpkgs/nixos-unstable"; # We want to use packages from the binary cache
    inputs.dream2nix.url = "github:nix-community/dream2nix";
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, dream2nix, ... }:
    let
      project = inputs.dream2nix.lib.init {
        # modify according to your supported systems
        systems = [ "x86_64-linux" ];
        config.projectRoot = ./.;
      };
    in project.makeFlakeOutputs {
      source = ./.;
    };
}
