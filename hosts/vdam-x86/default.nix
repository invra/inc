{ config, ... }:
{
  configurations.vdam-x86.module = {
    imports = with config.flake.modules.nixos; [
      base
    ];

    networking.hostName = "NixOS";
    hardware.facter.reportPath = ./facter.json;

    boot.initrd = {
      kernelModules = [
        "hid_generic"
        "virtio_pci"
        "virtio_blk"
        "virtio_gpu"
        "xhci_hcd"
        "xhci_pci"
        "kvm-amd"
        "virtio"
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
