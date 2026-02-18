{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
  ];

  services.sshd.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "discord" ];

  networking.firewall.allowedTCPPorts = [
    22
    21
    23
  ];

  environment.systemPackages = with pkgs; [
    helix
    foot
    mercurial
    discord
  ];
}
