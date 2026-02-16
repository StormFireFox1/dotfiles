{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./nix-settings.nix
  ];

  # Override boot loader settings - ISO uses different boot mechanism
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # Force hostname for rescue environment
  networking.hostName = lib.mkForce "rescue";

  # Force no autologin for Getty.
  services.getty.autologinUser = lib.mkForce null;

  # Set relatively simple password.
  users.users.ghost.hashedPassword = "$6$VZ4m6Jd5B1RhYUL9$8XruTUiPJnkgZE7xBsFigYDAj1HKCgzMVKfbeP9a0tXe.Bnlcg5R3AJMfGdVYF4vfDqmh/xSfEbk3adpOKCDW1";

  # Force OpenSSH to be open on a different port (31187)
  # and have root login allowed. This permits nixos-anywhere
  # to do its stuff.
  services.openssh = {
    ports = lib.mkForce [ 22 31187 ];
    settings = {
      PermitRootLogin = lib.mkForce "prohibit-password";
      AllowUsers = [ "ghost" "nixos" "root" ];
    };
  };

  # Rescue and recovery packages
  environment.systemPackages = with pkgs; [
    # Basic internet stuff
    openssh

    # Disk partitioning
    gparted
    parted

    # Data recovery
    ddrescue
    testdisk

    # Disk health monitoring
    smartmontools

    # Encryption
    cryptsetup

    # Filesystem tools
    dosfstools
    e2fsprogs
    ntfs3g
    btrfs-progs
    xfsprogs

    # Network diagnostics
    nmap
    iperf3

    # System monitoring
    lsof
    pciutils
    usbutils

    # Additional utilities
    hdparm
    nvme-cli
    mdadm
  ];
}
