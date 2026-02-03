{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.fireflake.nixos;
  types = lib.types;
in
{
  imports = [
    ./nix-settings.nix
    ./nvidia.nix
    ./desktop.nix
    ./server.nix
  ];

  options.fireflake.nixos = {
    timezone = lib.mkOption {
      type = types.string;
      description = "The timezone of the machine.";
      default = "America/Los_Angeles";
    };
    type = lib.mkOption {
      type = types.oneOf [
        "desktop"
        "server"
      ];
      description = "Type of NixOS machine. Either a desktop machine or server. Difference primarily stems on whether the installation will be headless or come with a DE.";
    };
  };

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [
      "btrfs"
      "cifs"
      "ntfs"
      "zfs"
    ];
    # Support cross-compilation.
    boot.binfmt.emulatedSystems = builtins.filter (x: x == pkgs.stdenv.hostPlatform.system) [
      "x86_64-linux"
      "aarch64-linux"
    ];
    security.tmpfiles.rules = [
      "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    ];

    networking.hostName = config.meta.hostname;
    networking.networkmanager.enable = true;

    time.timeZone = cfg.timezone;

    i18n.defaultLocale = "en_US.UTF-8";
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      jetbrains-mono
    ];
    fonts.fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };

    security.polkit.enable = true;

    # Define a user account. Don't fogget to set a password with ‘passwd’.
    users.users = {
      ghost = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "podman"
        ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          # TODO: (Matei) filter correct packages here.
        ];
      };
    };

    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    # TODO: (Matei) filter correct packages here.
    environment.systemPackages = with pkgs; [
      appimage-run
      argocd
      aria2
      autoconf
      automake
      bottles
      btop
      cargo
      cava
      cifs-utils
      croc
      direnv
      discord
      dive
      doggo
      dunst
      fd
      fish
      fluxcd
      fzf
      gcc
      gh
      gimp
      git
      github-cli
      gnumake
      go
      google-chrome
      gpu-screen-recorder
      gpu-screen-recorder-gtk
      home-manager
      hyprlock
      hyprpolkitagent
      jujutsu
      just
      k9s
      killall
      kitty
      kubectl
      kubectl-cnpg
      kubeseal
      lazygit
      luarocks
      mise
      neofetch
      neovim
      nextdns
      nh
      nixos-anywhere
      nodejs_24
      nushell
      obsidian
      obs-studio
      pavucontrol
      pdftk
      piper
      playerctl
      prismlauncher
      pywal
      qemu
      quickemu
      rclone
      ripgrep
      rustc
      ryubing
      samba
      signal-desktop
      simple-scan
      spotify
      sqlite
      starship
      step-cli
      taskwarrior3
      tealdeer
      texlive.combined.scheme-full
      tmux
      todoist
      todoist-electron
      tree-sitter
      unzip
      uv
      vscode
      waybar
      wget
      winetricks
      wineWowPackages.stable
      wineWowPackages.staging
      wofi
      yabridge
      yabridgectl
      yazi
      zip
    ];

    environment.localBinInPath = true;
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    programs.mtr.enable = true;
    # Setup universal rebinds for keyboard.
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "escape";
            };
          };
        };
      };
    };

    # Enable the OpenSSH daemon.
    # TODO: (Matei) harden this OpenSSH config.
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
    services.tailscale.enable = true;
    services.resolved.enable = true;
    services.fail2ban.enable = true;

    security.pki.certificateFiles = [
      "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ./stormnet-ca.crt
    ];

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [
      22
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
      22
      80
      443
    ];

    system.stateVersion = "24.11";
  };
}
