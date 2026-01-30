{ config, ... }:
{
  flake.modules.nixos.base = {
    users.groups.libvirtd.members = [ config.flake.meta.owner.username ];
    programs.virt-manager.enable = true;
    virtualisation = {
      libvirtd.enable = true;

      spiceUSBRedirection.enable = true;

      vmVariant.virtualisation = {
        memorySize = 1024 * 32;
        cores = 8;
        diskSize = 128 * 1024;
      };
    };
  };
}
