{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = ".git/config";
      programs = {
        nixfmt.enable = true;
        nixf-diagnose.enable = true;
      };
    };
  };
}
