{
  flake.modules.nixos.nvidia-gpu =
    { pkgs, config, ... }:
    {
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
      specialisation.nvidia-gpu.configuration = {
        services.xserver.videoDrivers = [ "nvidia" ];
      };
      programs.obs-studio.package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      nixpkgs.allowedUnfreePackages = [
        "nvidia-x11"
        "nvidia-settings"
      ];
    };
}
