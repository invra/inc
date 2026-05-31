{ config, ... }:
{
  configurations.laptop-x86.module = {
    imports = with config.flake.modules.nixos; [
      base
      nvidia-gpu
    ];

    networking.hostName = "NixOS";
    hardware.facter.reportPath = ./facter.json;

    boot = {
      initrd.availableKernelModules = [
        "thunderbolt"
        "xhci_hcd"
        "xhci_pci"
        "usbhid"
        "ahci"
        "nvme"
        "vmd"
      ];
      kernelModules = [ "kvm-intel" ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/0522bf8e-6244-4430-a3c6-c5898c9b6b7b";
        fsType = "ext4";
      };
      "/home" = {
        device = "/dev/disk/by-uuid/068428c3-c663-4955-849e-b595841e273f";
        fsType = "ext4";
      };
    };
    system.stateVersion = "25.11";
  };
}
