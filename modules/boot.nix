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
          # To fix `can't set config #1` for Novation Launchpad Pro MK3
          "usbcore.quirks=1235:012f:m"
        ];

        loader.systemd-boot.enable = true;

        kernel.sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.swappiness" = 10;
        };
      };
    };
}
