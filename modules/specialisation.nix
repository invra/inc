{
  flake.modules.nixos.nvidia-gpu =
    { pkgs, ... }:
    {
      specialisation.nvidia-gpu.configuration = {
        services.xserver.videoDrivers = [ "nvidia" ];
      };
      obs-studio.package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      nixpkgs.allowedUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"
      ];
    };
}
