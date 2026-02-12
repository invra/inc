{ config, ... }:
{
  configurations.macbook.module = {
    imports = with config.flake.modules.darwin; [
      base
    ];

    system.stateVersion = 6;
  };
}
