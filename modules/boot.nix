{
  flake.modules.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;

        kernelParams = [
          # Quiet down log messages
          "quiet"
          # Trust CPU with certain things
          "random.trust_cpu=on"
          # To fix `can't set config #1` for Novation Launchpad Pro MK3
          "usbcore.quirks=1235:012f:m"
        ];


        initrd = {
          systemd.enable = true;
          includeDefaultModules = false;
        };
        loader = {
          timeout = 1;

          grub = {
            enable = true;
            efiSupport = true;
            efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
            devices = ["nodev"];
            useOSProber = true;
            extraEntriesBeforeNixOS = false;
            extraEntries = ''
              menuentry "Reboot" {
                reboot
              }
              menuentry "Poweroff" {
                halt
              }
            '';
          };
        };

        kernel.sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.swappiness" = 10;
        };
      };

      # Disadbled because of slowness, and CPU has trust.
      systemd.services.systemd-boot-random-seed.enable = false;
    };
}
