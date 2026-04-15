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
