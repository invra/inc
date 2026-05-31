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
        device = "/dev/disk/by-uuid/195156cd-a0d3-41c7-bae7-b28301f278d3";
        fsType = "ext4";
      };
    };
    system.stateVersion = "25.11";
  };
}
