{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url =
    #   "github:nixos/nixpkgs/nixos-unstable"; # We want to use packages from the binary cache
    inputs.dream2nix.url = "github:nix-community/dream2nix";
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, dream2nix }:
    {};
}
