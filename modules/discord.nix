{
  inputs,
  ...
}:
{
  nixpkgs.allowedUnfreePackages = [
    "discord"
  ];
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    let
      version = "1.0.161";

      src = pkgs.fetchurl {
        url = "https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${version}/Discord.tar.gz";
        hash = "sha256-Xx4jSaVgK5j6u7/iIsUbu1xZx3/8Hnsde8DYb5bvCvg=";
      };

      discord-bootstrap = pkgs.stdenv.mkDerivation {
        pname = "discord";
        inherit version src;

        dontPatchELF = true;
        dontStrip = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out
          cp -r ./* $out/
          chmod +x $out/discord $out/updater_bootstrap

          runHook postInstall
        '';

        meta = {
          description = "Discord desktop client bootstrap";
          homepage = "https://discordapp.com/";
          license = lib.licenses.unfree;
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        };
      };

      desktopItem = pkgs.makeDesktopItem {
        name = "discord";
        exec = "discord --url -- %u";
        icon = "discord";
        desktopName = "Discord";
        genericName = "Instant Messenger";
        comment = "All-in-one voice and text chat for gamers";
        categories = [
          "Network"
          "InstantMessaging"
        ];
        mimeTypes = [ "x-scheme-handler/discord" ];
        startupWMClass = "discord";
      };

      launcher = pkgs.writeShellScript "discord-launcher" ''
        export LD_LIBRARY_PATH="${pkgs.addDriverRunpath.driverLink}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec ${discord-bootstrap}/discord "$@"
      '';

      discord = pkgs.buildFHSEnv {
        pname = "discord";
        inherit version;

        targetPkgs =
          p: with p; [
            alsa-lib
            atk
            at-spi2-atk
            at-spi2-core
            cairo
            cups
            dbus
            expat
            fontconfig
            freetype
            gdk-pixbuf
            glib
            gtk3
            libappindicator
            libcxx
            libdbusmenu
            libdrm
            libgbm
            libglvnd
            libnotify
            libpulseaudio
            libunity
            libuuid
            libva
            libx11
            libxcomposite
            libxcursor
            libxdamage
            libxext
            libxfixes
            libxi
            libxkbcommon
            libxrandr
            libxrender
            libxscrnsaver
            libxcb
            libxtst
            nspr
            nss
            pango
            pciutils
            pipewire
            speechd-minimal
            systemdLibs
            wayland
            zenity
            stdenv.cc.cc
          ];

        runScript = "${launcher}";

        extraInstallCommands = ''
          mkdir -p $out/share/icons/hicolor/256x256/apps
          ln -s ${discord-bootstrap}/discord.png $out/share/icons/hicolor/256x256/apps/discord.png
          ln -s ${desktopItem}/share/applications $out/share/
        '';

        meta = {
          description = "All-in-one voice and text chat for gamers";
          homepage = "https://discordapp.com/";
          license = lib.licenses.unfree;
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        discord = {
          package = if (pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86_64) then discord else pkgs.discord;
          equicord.enable = true;
        };
        config.plugins = {
          messageClickActions.enable = true;
          voiceChatDoubleClick.enable = true;
        };
      };
    };
}
