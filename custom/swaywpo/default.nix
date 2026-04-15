{
  perSystem =
    { pkgs, ... }:
    {
      devShells.swaywpo = pkgs.mkShell {
        packages = with pkgs; [
          zig
          zls
          jq
        ];
      };
      packages = {
        swaywpo = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "swaywpo";
          version = "release";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          buildInputs = with pkgs; [
            zig
          ];

          zigBuildFlags = [
            "-Doptimize=ReleaseSafe"
          ];

          postInstall = ''
            wrapProgram $out/bin/swaywpo \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq ]}
          '';

          outputs = [
            "out"
          ];

          meta.mainProgram = "swaywpo";
        });
      };
    };
}
