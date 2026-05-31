{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.auto = pkgs.mkShell (finalAttrs: {
        buildInputs = with pkgs; [
          openssl
          clang
          swift
          zig
          zls
          jq
          kdePackages.qtbase
        ];
        nativeBuildInputs =
          with pkgs;
          [
            swiftpm
            kdePackages.wrapQtAppsHook
          ]
          ++ finalAttrs.runtimeInputs;
        runtimeInputs = with pkgs; [
          swift-corelibs-libdispatch
        ];
        shellHook = with finalAttrs; ''
          export CC="clang"
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'${lib.makeLibraryPath runtimeInputs}'
        '';
      });
      packages = {
        # TODO: Implement a build script for swift.
        swift-bootstrapper = { };
        auto = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "auto";
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

          meta.mainProgram = "auto";
        });
      };
    };
}
