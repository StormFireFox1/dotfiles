{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    defaults = {
      # Subtle system-wide window corner rounding (macOS 26.4+, same keys OmniWM's
      # "System-wide Window Corners" control writes). Applies to all standard and
      # panel windows; affected apps need a relaunch to pick it up.
      CustomUserPreferences."NSGlobalDomain" = {
        NSConvolutionOverride1 = 4.0;
        NSConvolutionOverride2 = 4.0;
      };
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      finder = {
        AppleShowAllFiles = true; # hidden files
        AppleShowAllExtensions = true; # file extensions
        _FXShowPosixPathInTitle = true; # title bar full path
        ShowPathbar = true; # breadcrumb nav at bottom
        ShowStatusBar = true; # file count & disk space
      };
      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
      };
    };
  };
}
