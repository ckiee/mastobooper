{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/nixos-unstable"; # We want to use packages from the binary cache
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = rec {
          mastobooper = with pkgs;
            rustPlatform.buildRustPackage rec {
              pname = "mastobooper";
              version = "0.1.0";

              src = ./.;

              buildInputs = [ alsaLib ];
              nativeBuildInputs = [ pkg-config ];
              cargoSha256 =
                "sha256-sG1TfIt2cC1tHTU7aMzRSk0z7dOVLQUZ7nozQVtKfdA=";

              meta = with lib; {
                description = "mastobooper";
                license = licenses.unlicense;
              };
            };
          default = mastobooper;
        };

        defaultPackage = packages.default;

        apps = rec {
          mastobooper = flake-utils.lib.mkApp {
            name = "mastobooper";
            drv = packages.mastobooper;
          };
          default = mastobooper;
        };

        defaultApp = apps.default;

        devShell = pkgs.mkShell {
          CARGO_INSTALL_ROOT = "${toString ./.}/.cargo";

          nativeBuildInputs = with pkgs; [ pkg-config ];
          buildInputs = with pkgs; [ cargo rustc git alsaLib ];
        };
      });
}
