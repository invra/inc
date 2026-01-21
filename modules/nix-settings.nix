{ lib, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      nix.package =
        pkgs.nixVersions
        |> lib.attrNames
        |> lib.filter (lib.hasPrefix "nix_")
        |> lib.naturalSort
        |> lib.last
        |> lib.flip lib.getAttr pkgs.nixVersions
        |> lib.mkDefault;

      nix.settings = {
        keep-outputs = true;
        experimental-features = [
          "flakes"
          "nix-command"
          "recursive-nix"
          "pipe-operators"
        ];
        extra-experimental-features = [
          "pipe-operators"
        ];
        extra-system-features = [
          "recursive-nix"
        ];
      };
    };
in
{
  flake.modules = {
    nixos.base = polyModule;
    darwin.base = polyModule;
    homeManager.base = polyModule;
  };
}
