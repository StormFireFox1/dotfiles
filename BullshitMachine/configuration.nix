# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  driveFolders = [
    "Dumps"
    "Backups"
    "Media"
    "Steam"
  ];
  mounts = map (x: "/mnt/StormDrive/" + x) driveFolders;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [
    "cifs"
    "ntfs"
  ];

  networking.hostName = "BullshitMachine"; # Define your hostname.
  networking.extraHosts = ''
    172.16.90.2 gatekeeper.storm
  '';
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  nixpkgs.config.allowUnfree = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    vollkorn
    fira-code
    jetbrains-mono
  ];
  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
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
  hardware.nvidia-container-toolkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't fogget to set a password with ‘passwd’.
  users.users = {
    ghost = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "uinput"
        "podman"
      ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
      ];
    };
  };

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.thunderbird.enable = true;
  programs.hyprland = {
    enable = true;
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
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    claude-code
    croc
    direnv
    discord
    dive
    doggo
    dunst
    fd
    fish
    flameshot
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
    hyprpaper
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
    playerctl
    prismlauncher
    pywal
    qemu
    quickemu
    rclone
    ripgrep
    rustc
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
  environment.variables = {
    "KITY_DISABLE_WAYLAND" = "0";
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STAET_HOME = "$HOME/.local/state";
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        firefox
      '';
      mode = "0755";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
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
  services.tailscale.enable = true;
  services.resolved.enable = true;
  services.nextdns = {
    enable = true;
    arguments = [
      "-config"
      "d3c471"
      "-cache-size"
      "10MB"
    ];
  };
  services.fail2ban.enable = true;

  systemd.tmpfiles.rules = map (x: "d " + x + " 0755 ghost users -") mounts;
  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };
  fileSystems = lib.attrsets.genAttrs mounts (mount: {
    device = "//StormDrive.local/" + builtins.baseNameOf mount;
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=${config.age.secrets.StormDriveSmbKey.path},uid=1000,gid=100" ];
  });

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
  networking.interfaces.eno2.wakeOnLan.enable = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
