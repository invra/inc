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

    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "vmd"
        "ahci"
        "nvme"
      ];
      kernelModules = [ "kvm-amd" ];
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
