# Filesystem declarations matching the labels baked into a NixOS SD image.
# Must be kept in sync with the upstream sd-image module so that
# nixos-rebuild switch works after imaging the card.
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };
}
