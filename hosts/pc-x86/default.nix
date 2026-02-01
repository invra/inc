{ config, ... }:
let
  this = config;
in
{
  configurations.pc-x86.module = {
    imports = with this.flake.modules.nixos; [
      base
    ];
    networking = {
      hostId = "0e8e163d";
      hostName = "NixOS";
    };
    facter.reportPath = ./facter.json;

    boot.initrd = {
      kernelModules = [
        "xhci_hcd"
        "xhci_pci"
        "usbhid"
        "hid_generic"
        "nvme"
        "ahci"
        "sd_mod"
        "kvm-amd"
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
        device = "/dev/disk/by-uuid/5870ec89-f90d-434c-8a71-46a78213c93d";
        fsType = "ext4";
      };
    };
    system.stateVersion = "24.11";
  };
}
