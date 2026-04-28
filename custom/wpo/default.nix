{
  perSystem =
    { pkgs, ... }:
    {
      devShells.wpo = pkgs.mkShell {
        packages = with pkgs; [
          zig
          zls
          jq
        ];
      };
      packages = {
        wpo = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "wpo";
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
            wrapProgram $out/bin/wpo \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq ]}
          '';

          outputs = [
            "out"
          ];

          meta.mainProgram = "wpo";
        });
      };
    };
}
