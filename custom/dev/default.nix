{
  perSystem =
    { pkgs, ... }:
    {
      devShells.dev = pkgs.mkShell {
        packages = with pkgs; [
          zig
          zls
        ];
      };
      packages = {
        dev = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "dev";
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
