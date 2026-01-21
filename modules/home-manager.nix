{ config, ... }:
{
  flake.modules.homeManager.base =
    { darwin, ... }:
    {

      home = {
        username = config.flake.meta.owner.username;
        homeDirectory =
          if darwin then
            "/Users/${config.flake.meta.owner.username}"
          else
            "/home/${config.flake.meta.owner.username}";
      };
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
    };
}
