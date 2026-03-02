{ config, ... }:
let
  this = config;
in
{
  configurations.vdam-x86.module = {
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
        "virtio"
        "virtio_pci"
        "virtio_blk"
        "virtio_gpu"
      ];

      availableKernelModules = [
        "usb_storage"
        "thunderbolt"
      ];
    };

    services.xserver.videoDrivers = [
      "modesetting"
      "virtio"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/vda2";
        fsType = "ext4";
      };
    };
    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };
    system.stateVersion = "24.11";
  };
}
