{
  flake.modules.darwin.base = {
    targets.darwin = {
      dock = {
        enable = true;
      };

      defaults = {
        NSGlobalDomain = {
          AppleShowAllExtensions = false;
          # Cmd + Ctrl to drag from window anywhere not needing it's chrome
          NSWindowShouldDragOnGesture = true;
          NSAutomaticSpellingCorrectionEnabled = false;
          # Default save files to disk not iCloud
          NSDocumentSaveNewDocumentsToCloud = false;
          # Force set icon size to default value
          NSTableViewDefaultSizeMode = 2;
          # Singular enum, of value Dark. https://mynixos.com/nix-darwin/option/system.defaults.NSGlobalDomain.AppleInterfaceStyle
          AppleInterfaceStyle = "Dark";
          AppleHighlightColor = "0.968627 0.831373 1.000000 Purple";
          AppleAccentColor = 5;
        };

        "com.apple.screencapture" = {
          location = "~/Pictures";
          type = "png";
          target = "clipboard";
          disable-shadow = true;
        };

        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = false;
          GloballyEnabled = false;
        };

        "com.apple.menuextra.clock" = {
          Show24Hour = true;
          ShowSeconds = true;
        };

        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.finder" = {
          AppleShowAllExtensions = true;
          # List view
          FXPreferredViewStyle = "Nlsv";
          # Search the current folder
          FXDefaultSearchScope = "SCcf";
          # List with directorys at first
          _FXSortFoldersFirst = true;
          # Disable finder tabs (due to WM)
          FinderSpawnTab = false;
          # Delete bin in 30 days
          FXRemoveOldTrashItems = true;
          # Disable change fs-extension warning
          FXEnableExtensionChangeWarning = false;
          showWindowTitlebarIcons = false;
          NSToolbarTitleViewRolloverDelay = 0.2;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          CreateDesktop = false;
          QuitMenuItem = true;
          NewWindowTarget = "Home";
        };

        "com.apple.dock" = {
          autohide = true;
          orientation = "bottom";
          tilesize = 32;
          minimize-to-application = true;
          show-recents = false;
          wvous-br-corner = 1;
          size-immutable = true;
        };

        # Disable AI bullshit
        "com.apple.CloudSubscriptionFeatures.optIn"."545129924" = false;
      };
    };
  };
}
