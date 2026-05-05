{
  perSystem =
    { pkgs, ... }:
    {
      devShells.cbl = pkgs.mkShell {
        packages = with pkgs; [
          zig
          zls
        ];
      };
      packages = {
        certified-by-lincoln = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "certified_by_lincoln";
          version = "release";

          src = ./.;

          deps = pkgs.callPackage ./build.zig.zon.nix {
            name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
          };

          buildInputs = with pkgs; [
            zig
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
    };
}
