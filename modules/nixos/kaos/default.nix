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
    inputs.orca-nix.nixosModules.default
    inputs.hermes-agent.nixosModules.default
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
    # Capitalized to match the nixosConfigurations attr name so nh resolves it;
    # meta.hostname ("kaos") stays lowercase for agenix secret keys.
    networking.hostName = "Kaos";
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
      ++ agentCliPackages
      ++ [ signal-cli ];

    environment.localBinInPath = true;

    programs.mtr.enable = true;
    programs.zsh.enable = true;
    # Headless Orca server, reachable over Tailscale (tailscale0 is a trusted
    # interface, so the service port needs no extra firewall rule).
    services.orca-ide = {
      enable = true;
      user = "paseo";
      pairingAddress = "kaos.ts.storm";
      extraPackages = agentCliPackages ++ [
        pkgs.git
        pkgs.gh
      ];
    };

    # Hermes Agent gateway (native hardened service). OpenRouter key comes from
    # the HermesOpenRouterApiKey agenix secret; edit it with
    # `agenix -e secrets/HermesOpenRouterApiKey.age` and rebuild.
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      environmentFiles = [ config.age.secrets.HermesOpenRouterApiKey.path ];
      settings.model.default = "deepseek/deepseek-v4.1-flash-1017";
    };

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

    # Declarative daemon config: installed to /var/lib/paseo/config.json on every
    # daemon start, overwriting any runtime edits made via the CLI or app —
    # including profile, provider, and browser-tool toggles made in the phone
    # app. Port app-made edits here or they are lost on the next daemon start.
    # The daemon password lives in the agenix secret PaseoPassword and reaches
    # the daemon as PASEO_PASSWORD (env overrides config.json auth). Rotate it
    # with `agenix -e secrets/PaseoPassword.age`, then rebuild.
    # daemon.appendSystemPrompt carries the sudo terminal-handoff protocol:
    # password-needing commands run in a Paseo terminal so the user can type
    # the password from their phone; never through chat.
    services.paseo.settings = {
      version = 1;
      daemon = {
        listen = "127.0.0.1:6767";
        mcp.injectIntoAgents = true;
        browserTools.enabled = true;
        appendSystemPrompt = "Sudo password handling: never run a command that needs a password in your shell tool - it has no TTY, so the password prompt cannot be answered and the call hangs. Instead: create a Paseo terminal session (create_terminal), run the sudo command there, then message the user in chat telling them which terminal is waiting for their sudo password. End your turn and wait until they confirm. Afterwards capture_terminal to verify the result. Never ask the user to paste a password into chat or write it anywhere.";
        agentProfiles = [
          {
            id = "legacy_favorite:omp:openrouter%2Fz-ai%2Fglm-5.3-flash";
            name = "openrouter/z-ai/glm-5.3-flash";
            provider = "omp";
            model = "openrouter/z-ai/glm-5.3-flash";
          }
          {
            id = "legacy_favorite:omp:openrouter%2Fdeepseek%2Fdeepseek-v4.1-flash-1017";
            name = "openrouter/deepseek/deepseek-v4.1-flash-1017";
            provider = "omp";
            model = "openrouter/deepseek/deepseek-v4.1-flash-1017";
          }
        ];
        cors.allowedOrigins = [ "https://app.paseo.sh" ];
        relay.enabled = false;
      };
      app.baseUrl = "https://app.paseo.sh";
      agents.providers = {
        copilot.enabled = false;
        codex.enabled = false;
        claude.enabled = false;
        opencode.enabled = false;
        antigravity.enabled = false;
        muse.enabled = false;
        omp.enabled = true;
      };
    };

    systemd.services.paseo.serviceConfig.EnvironmentFile = config.age.secrets.PaseoPassword.path;

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
