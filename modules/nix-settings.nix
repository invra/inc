{
  config,
  lib,
  ...
}:
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

      nix = {
        settings = {
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
          trusted-users = [
            "root"
            "@wheel"
            config.flake.meta.owner.username
          ];
          extra-substituters = [ "https://umbriel.cachix.org" "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };
        gc = {  
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 1d";
          persistent = true;
        };
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
