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
        packages.mastobooper = with pkgs;
          rustPlatform.buildRustPackage rec {
            pname = "mastobooper";
            version = "0.1.0";

            src = ./.;

            buildInputs = [ alsaLib ];
            nativeBuildInputs = [ pkg-config ];
            cargoSha256 = "sha256-ug/4GJS8VPm/k9xzdjr3/DypNL/ounC3ua+PesT/rxs=";

            meta = with lib; {
              description = "mastobooper";
              license = licenses.unlicense;
            };
          };

        apps.mastobooper = flake-utils.lib.mkApp {
          name = "mastobooper";
          drv = packages.mastobooper;
        };
        defaultApp = apps.mastobooper;
        defaultPackage = packages.mastobooper;

        devShell = pkgs.mkShell {
          CARGO_INSTALL_ROOT = "${toString ./.}/.cargo";

          nativeBuildInputs = with pkgs; [ pkg-config ];
          buildInputs = with pkgs; [ cargo rustc git alsaLib ];
        };
      });
}
