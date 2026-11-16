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
      "omniwm"
      "raycast"
      "cleanshot"
      "betterdisplay"

      # Developer
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
    taps = [ ];
  };
}
