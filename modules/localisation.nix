{
  flake.modules.nixos.base = {
    i18n = {
      defaultLocale = "en_AU.UTF-8";
      supportedLocales = [
        "en_AU.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];

      extraLocaleSettings = {
        LC_CTYPE = "en_AU.UTF-8";
        LC_ADDRESS = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MESSAGES = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
        LC_COLLATE = "en_AU.UTF-8";
      };
    };
  };
  flake.modules.darwin.base = {
    targets.darwin.defaults.NSGlobalDomain = {
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      AppleICUForce24HourTime = true;
      AppleTemperatureUnit = "Celsius";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = true; 
    };   
  };
}
