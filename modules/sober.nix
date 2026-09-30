{
  flake.modules.nixos.base =
    let
      nix-flatpak = fetchTarball {
        url = "https://github.com/gmodena/nix-flatpak/archive/v0.7.0.tar.gz";
        sha256 = "sha256-7ZCulYUD9RmJIDULTRkGLSW1faMpDlPKcbWJLYHoXcs=";
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
