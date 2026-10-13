{
  flake.modules.nixos.base =
    let
      nix-flatpak = fetchTarball {
        url = "https://github.com/gmodena/nix-flatpak/archive/refs/tags/v0.8.0.tar.gz";
        sha256 = "sha256-OsZ/I7v3ArCrk0XOUvkiU1dFtGtE1qZTHRGjvBXIKUU=";
      };
    in
    {
      imports = [
        "${nix-flatpak}/modules/nixos.nix"
      ];

      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
        ];
      };
    };
}
