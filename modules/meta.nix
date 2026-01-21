{
  config,
  inputs,
  lib,
  ...
}:
let
  gitlab = {
    domain = "gitlab.com";
    username = "invra";
  };
  forge = "gitlab";
  owner = gitlab.username;
  name = "inc";
  defaultBranch = "main";
  flakeUri = "git+https://${gitlab.domain}/${owner}/${name}";
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
