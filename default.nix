{ pkgs ? import ./pkgs.nix {} }: with pkgs;

buildGoPackage {
  name = "unrar";
  src = lib.cleanSource ./.;

  goPackagePath = "gitlab.com/transumption/unstable/unrar";
  doCheck = true;
}
