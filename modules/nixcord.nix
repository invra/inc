{ inputs, ... }:
{
  nixpkgs.allowedUnfreePackages = [
    "discord"
  ];
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        discord = {
          enable = !(pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64);
          vencord.enable = !(pkgs.stdenv.isLinux);
          equicord.enable = pkgs.stdenv.isLinux;
        };
        vesktop.enable = (pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64);

        config = {
          useQuickCss = true;
          themeLinks = [ ];
          frameless = false;
          plugins = {
            iLoveSpam.enable = true;
            betterSettings.enable = true;
            crashHandler.enable = true;
            fixSpotifyEmbeds = {
              enable = true;
              volume = 9.0;
            };
            fixYoutubeEmbeds.enable = true;
            imageZoom.enable = true;
            spotifyControls.enable = !(pkgs.stdenv.isLinux);
            musicControls.enable = pkgs.stdenv.isLinux;
            noF1.enable = true;
            OnePingPerDM.enable = true;
            openInApp.enable = true;
            quickReply.enable = true;
            spotifyCrack.enable = true;
            spotifyShareCommands.enable = true;
            voiceChatDoubleClick.enable = true;
            voiceDownload.enable = true;
            voiceMessages = {
              enable = true;
              echoCancellation = false;
              noiseSuppression = false;
            };
            volumeBooster = {
              enable = true;
              multiplier = 2.0;
            };
            messageClickActions = {
              enable = true;
              enableDoubleClickToEdit = true;
            };
            webRichPresence.enable = true;
            youtubeAdblock.enable = true;
          };
        };
      };
    };
}
