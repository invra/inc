{ config, ... }:
{
  flake.modules = {
    darwin.base = {
      system.primaryUser = config.flake.meta.owner.username;
      security.pam.services.sudo_local.touchIdAuth = true;
    };
    nixos.base = {
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
        tpm2.enable = true;
      };
      users.users.${config.flake.meta.owner.username}.extraGroups = [
        "wheel"
        "systemd-journal"
      ];
    };
  };
}
