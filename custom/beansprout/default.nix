{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.beansprout = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "beansprout";
        version = "release";

        src = inputs.beansprout-src;

        deps = pkgs.callPackage ./build.zig.zon.nix {
         name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
        };

        buildInputs = with pkgs; [
          zig
        ];

        nativeBuildInputs = with pkgs; [
          wayland
          wayland-scanner
          wayland-protocols
          pixman
          fcft
          libxkbcommon
          pkg-config
        ];

        zigBuildFlags = [
          "--system"
          "${finalAttrs.deps}"
          "-Doptimize=ReleaseSafe"
        ];

        outputs = [
          "out"
        ];
      });
    };
}
