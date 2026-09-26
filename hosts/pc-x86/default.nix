{ config, ... }:
{
  configurations.pc-x86.module = {
    imports = with config.flake.modules.nixos; [
      base
    ];

    networking.hostName = "NixOS";
    hardware.facter.reportPath = ./facter.json;

    boot.initrd = {
      kernelModules = [
        "hid_generic"
        "xhci_hcd"
        "xhci_pci"
        "kvm-amd"
        "sd_mod"
        "usbhid"
        "nvme"
        "ahci"
      ];

      availableKernelModules = [
        "usb_storage"
        "thunderbolt"
      ];
    };

    services.xserver.videoDrivers = [
      "modesetting"
      "amdgpu"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/75029aff-3d90-4d1d-98b0-3ce9b7b47c84";
        fsType = "ext4";
      };
    };
    system.stateVersion = "26.05";
  };
}
