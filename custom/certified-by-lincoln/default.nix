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

          buildInputs = with pkgs; [
            zig
          ];

          zigBuildFlags = [
            "-Doptimize=ReleaseSafe"
          ];

          outputs = [
            "out"
          ];
        });
      };
    };
}
