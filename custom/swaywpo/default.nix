{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        swaywpo = pkgs.stdenv.mkDerivation {
          pname = "swaywpo";
          version = "1.0.0";
          src = ./.;

          enableParallelBuilding = true;
          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
          ];
        };
      };
    };
}
