{ lib, config, ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    users.groups = {  
      libvirtd.members = [ config.flake.meta.owner.username ];
      docker.members = [ config.flake.meta.owner.username ];
    };

    programs.virt-manager.enable = true;
    environment.systemPackages = with pkgs; [ winboat ];
    virtualisation = {
      libvirtd.enable = true;
      docker.enable = true;

      spiceUSBRedirection.enable = true;

      vmVariant.virtualisation = {
        memorySize = 1024 * 32;
        cores = 8;
        diskSize = 128 * 1024;
      };
    };

    systemd.services = {
      libvirtd.serviceConfig.Type = lib.mkForce "idle";
      libvirt-guests.enable = false;
    };
  };
}
