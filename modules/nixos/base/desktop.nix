{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.fireflake.nixos.desktop;
  types = lib.types;
in
{

  options.fireflake.nixos.desktop = {
    dedicatedGraphicsType = lib.mkOption {
      type = types.oneOf [
        "nvidia"
        "amd"
      ];
      description = "Brand of dedicated graphics card installed in desktop machine.";
    };
    wakeOnLanInterface = lib.mkOption {
      type = types.string;
      description = "What network interface will be used to enable Wake-on-LAN support.";
    };
  };

  config =
    lib.mkIf cfg.type == "desktop" {
      # Configure keymap in X11
      services.xserver.xkb.layout = "us";
      services.xserver.xkb.options = "eurosign:e,caps:escape";
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.libinput.enable = true;
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        vollkorn
        fira-code
      ];

      services.printing.enable = true;

      services.gnome.gnome-keyring.enable = true;

      services.pipewire = {
        enable = true;
        audio.enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        jack.enable = true;
      };

      hardware.bluetooth.enable = true;
      services.blueman.enable = true;

      programs.fish.enable = true;
      programs.firefox.enable = true;
      programs.thunderbird.enable = true;
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "ghost" ];
      };

      users.users.ghost.extraGroups = [
        "input"
        "uinput"
      ];

      services.ratbagd.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
          addresses = true;
        };
      };
      services.nextdns = {
        enable = true;
        arguments = [
          "-config"
          "d3c471"
          "-cache-size"
          "10MB"
        ];
      };
      security.wrappers."mount.cifs" = {
        program = "mount.cifs";
        source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
        owner = "root";
        group = "root";
        setuid = true;
      };
      networking.interfaces.${cfg.wakeOnLanInterface}.wakeOnLan.enable = true;

      environment.variables = {
        "KITY_DISABLE_WAYLAND" = "0";
      };
      environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            firefox
          '';
          mode = "0755";
        };
      };
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
}
