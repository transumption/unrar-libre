{
  # TODO: remove, see https://git.io/Jfku9
  edition = 201909;

  inputs.nixpkgs.uri = "nixpkgs/nixos-20.03-small";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      nixpkgsFor = forAllSystems (
        system:
          import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          }
      );
    in
      {
        overlay = final: prev: with final; {
          unrar-libre = buildGoModule {
            name = "unrar-libre";
            src = self;

            doCheck = true;
            modSha256 = "sha256-Sa40EIpzZH0Dv770gOD2qqIvK2ch6PciRNtBoeS3GdM=";
          };
        };

        packages = forAllSystems (
          system: {
            inherit (nixpkgsFor.${system}) unrar-libre;
          }
        );

        defaultPackage = forAllSystems (system: self.packages.${system}.unrar-libre);

        devShell = forAllSystems (
          system:
            with nixpkgsFor.${system};
            mkShell {
              buildInputs = [ nixpkgs-fmt ];
              inputsFrom = [ unrar-libre ];

              shellHook = ''
                unset GOPATH
              '';
            }
        );
      };
}
