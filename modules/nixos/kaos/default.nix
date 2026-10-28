{
  lib,
  pkgs,
  config,
  inputs,
  meta,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  paseo = inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system};
  agentCliPackages = [
    llmAgents.pi
    llmAgents.omp
    llmAgents.opencode
  ];
  cfg = config.fireflake.nixos;
in
{
  imports = [
    ../../agenix
    ../../misc/ssh-keys.nix
    ../base/nix-settings.nix
    ../base/server.nix
  ];

  options.fireflake.nixos = {
    timezone = lib.mkOption {
      type = lib.types.str;
      description = "The timezone of the machine.";
      default = "America/Los_Angeles";
    };
    type = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "server"
      ];
      description = "Type of NixOS machine. Either a desktop machine or server.";
    };
  };

  config = {
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

    users.users = {
      ghost = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "podman"
        ];
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
      paseo = {
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
        packages =
          with pkgs;
          [
            gh
            python3
            fish
            nushell
            jujutsu
            uv
            fd
            ripgrep
          ]
          ++ agentCliPackages;
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

    environment.systemPackages =
      with pkgs;
      [
        autoconf
        automake
        btop
        croc
        doggo
        dunst
        fastfetch
        fd
        fish
        fzf
        gcc
        git
        gh
        gnumake
        home-manager
        killall
        neovim
        nh
        nixos-anywhere
        nushell
        podman-compose
        rclone
        ripgrep
        samba
        sqlite
        starship
        step-cli
        tealdeer
        tmux
        tree-sitter
        unzip
        wget
        yazi
        zip
      ]
      ++ agentCliPackages;

    environment.localBinInPath = true;

    programs.mtr.enable = true;
    programs.zsh.enable = true;

    services.paseo = {
      enable = true;
      package = paseo.default;
      openFirewall = true;
      listenAddress = "0.0.0.0";
      inheritUserEnvironment = true;
      hostnames = [
        ".bobcat-gopher.ts.net"
        ".ts.storm"
        ".storm"
      ];
    };

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
      ../base/stormnet-ca.crt
    ];

    networking.firewall = {
      allowedTCPPorts = [
        22
        80
        443
        6767
      ];
      allowedUDPPorts = [
        22
        80
        443
        6767
      ];
      trustedInterfaces = [ "tailscale0" ];
    };

    boot.swraid.enable = lib.mkForce false;

    system.stateVersion = "25.11";
  };
}
