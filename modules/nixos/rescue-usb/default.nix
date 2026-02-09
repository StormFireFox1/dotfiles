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
