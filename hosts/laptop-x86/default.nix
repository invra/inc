{ config, ... }:
let
  this = config;
in
{
  configurations.laptop-x86.module =
    { config, ... }:
    {
      imports = with this.flake.modules.nixos; [
        base
        nvidia-gpu
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
          "vmd"
          "ahci"
          "nvme"
        ];
        kernelModules = [ "kvm-intel" ];
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
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
      system.stateVersion = "24.11";
    };
}
