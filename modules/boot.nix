{
  flake.modules.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_6_18;

        kernel.sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.swappiness" = 10;
        };

        initrd = {
          systemd.enable = true;
          includeDefaultModules = false;
        };

        kernelParams = [
          "splash"
          "quiet"
          "loglevel=3"
          "udev.log-priority=3"
        ];

        loader = {
          timeout = 1;
          grub = {
            enable = true;
            efiSupport = true;
            # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
            efiInstallAsRemovable = true;
            devices = [ "nodev" ];
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

        # Graphical boot
        plymouth = {
          enable = true;
          extraConfig = ''
            [Daemon]
            ShowDelay=0
          '';
        };

      };

      # Greeter
      services.displayManager.gdm.enable = true;
    };
}
