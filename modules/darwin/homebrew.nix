{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    casks = [
      # OS
      "raycast"
      "cleanshot"
      "betterdisplay"

      # Developer
      "alacritty"
      "kitty"
      "warp"
      "1password"
      "mullvad-vpn"
      "wireshark-app"
      "secretive"

      # Art
      "inkscape"
      "gimp"
      "obs"
      "figma"

      # Media
      "devonthink"
      "calibre"
      "firefox"
    ];
    brews = [ ];
    taps = [
      "nikitabobko/tap"
    ];
  };
}
