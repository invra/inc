{ config, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      security = {
        rtkit.enable = true;
        sudo.enable = false;
        doas = {
          enable = true;
          extraRules = [
            {
              users = [ config.flake.meta.owner.username ];
              keepEnv = true;
              persist = true;
            }
          ];
        };
      };
      users.users.${config.flake.meta.owner.username}.extraGroups = [
        "wheel"
        "systemd-journal"
      ];
    };

  flake.modules.darwin.base = {
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
