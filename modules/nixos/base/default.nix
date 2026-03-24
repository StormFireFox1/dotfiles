{
  config,
  lib,
  pkgs,
  inputs,
  meta,
  ...
}:
let
  cfg = config.fireflake.nixos;
  types = lib.types;
in
{
  imports = [
    ../../agenix
    ../../misc/ssh-keys.nix
    ./nix-settings.nix
    ./nvidia.nix
    ./desktop.nix
    ./server.nix
  ];

  options.fireflake.nixos = {
    timezone = lib.mkOption {
      type = types.str;
      description = "The timezone of the machine.";
      default = "America/Los_Angeles";
    };
    type = lib.mkOption {
      type = types.enum [
        "desktop"
        "server"
      ];
      description = "Type of NixOS machine. Either a desktop machine or server. Difference primarily stems on whether the installation will be headless or come with a DE.";
    };
  };

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader = {
      grub.enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [
      "btrfs"
      "cifs"
      "ntfs"
    ];
    # Support cross-compilation.
    boot.binfmt.emulatedSystems = builtins.filter (x: x != pkgs.stdenv.hostPlatform.system) [
      "x86_64-linux"
      "aarch64-linux"
    ];
    systemd.tmpfiles.rules = [
      "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
    ];

    networking.hostName = meta.hostname;
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
        openssh.authorizedKeys.keys = config.fireflake.sshKeys;
        packages = with pkgs; [
          direnv
          gh
          jujutsu
          just
          k9s
          kubectl
          kubectl-cnpg
          kubeseal
          lazygit
          luarocks
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
    environment.systemPackages = with pkgs; [
      autoconf
      automake
      btop
      croc
      doggo
      dunst
      fd
      fish
      fzf
      gcc
      git
      gnumake
      home-manager
      killall
      fastfetch
      neovim
      nh
      nixos-anywhere
      nushell
      rclone
      ripgrep
      samba
      sqlite
      step-cli
      starship
      tealdeer
      tmux
      tree-sitter
      unzip
      wget
      yazi
      zip
    ];

    environment.localBinInPath = true;

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
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "ghost" ];
      };
    };
    services.fail2ban.enable = true;
    services.resolved.enable = true;
    services.tailscale.enable = true;

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
