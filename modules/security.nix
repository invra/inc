{ config, ... }:
{
  flake.modules.darwin.base = {
    system.primaryUser = config.flake.meta.owner.username;
  };
  flake.modules.nixos.base = {
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
