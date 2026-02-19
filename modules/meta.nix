{
  config,
  inputs,
  lib,
  ...
}:
let
  hg-sourcehut = {
    domain = "hg.sr.ht";
    username = "invra";
  };
  forge = "hg-sourcehut";
  owner = hg-sourcehut.username;
  name = "inc";
  defaultBranch = "default";
  flakeUri = "git+https://${hg-sourcehut.domain}/~${owner}/${name}";
in
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.flake.meta = lib.mkOption {
    type = lib.types.anything;
  };
  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    flake = {
      meta = {
        owner = {
          email = "identificationsucks@gmail.com";
          name = "Invra";
          username = "invra";
          matrix = "@invranet:matrix.org";
        };
        repo = {
          inherit
            forge
            owner
            name
            defaultBranch
            flakeUri
            ;
        };
        nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
      };

      modules = {
        nixos.base = {
          users.users.${config.flake.meta.owner.username} = {
            isNormalUser = true;
            initialPassword = "";
            extraGroups = [ "input" ];
          };

          nix.settings.trusted-users = [ config.flake.meta.owner.username ];
        };
      };
    };
  };
}
