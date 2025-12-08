{
  config,
  pkgs,
  lib,
  ...
}:
{
  options =
    with lib;
    with types;
    {
      stormhub.ssh-keys = mkOption {
        type = listOf str;
        description = "The SSH keychain for all keys owned by Storm_FireFox1";
      };
    };

  config.stormhub = {
    ssh-keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDZIYxNcxuRY+U9v6zdhXRLLZI8dK/hqs+RjW8VcG/1NewvYfDHjXlHXlct6IBKKpaCwNoFTJgIM8/uvJqYWoSup7gIf5p60ofh2OYj1WjhdlzqgwK/k0J2QoiZKl8+ktwGm7d8aaeROiEyVCKl8Jm+HamrZz38yBwAMElnt2q+EpByZWJ+kd6+1ZpXzaJiCWTo9pZ7ewlXOFpH7XIS5IQl2JTlBH1Z7XA47K6ExvDYn9KF83S3CpmBX6WFL4tpdcHW6GM0E/30+itomLUt+l5xV5cWbvqaxsfyh3J8NsDuXt65XLBAAaImi3c86sj9JciptSUsPyblGdEwnOULN0+J810j4xUFsttgOhRi9s/boRoQeyHvsvNi3i0Psht02rpB6pRNSW+zClD0u10WBPKUfY7kilmpE6jeLGljxUX8HQACr5ExEhmwi8ioxrXwQJvLd2hcoE3R8fZci0NupaHP/rnB8B1DRzmG10NpsNLH9A50CfhRw3L8LS/zoENFdbaQXZiTAL02Gw89KNwOcUownNFMPKllWcbLYdzd73eDxrijHOPQzwScNkn5tJb7r7Mk3WXjdn0XOxjA2/Qo/SWh1ddpXdJFs7WndSLF+ngWbkbMtWFL2r6r+IJPQqY/pT9KAfH/mG4WKzkpEoKI/zcXwVgZ3vzXLFEZGog6lgTYyw== Storm_FireFox1 (Termius)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAojWD+JmLRKgTR5UWzGIbsN5/Q/Z8R5Hz3bfsOroO+e Storm_FireFox1 (Windows)"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJH5pTZBksQcsbM2jTB41edcCilUm3E+6xzI3PTFldAMuZAc43MntaZCd/Nv8leUQO5ja7LjOE6hvJEFDQVx5EA= Storm_FireFox1 (Secretive)"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQf3Uh5gPIC9HmM6KiUdplTb8L7gaFEmVujPytGWh0UW2ABWw6aDyvG8JjixbzGICrLu3EqZP2yUYcBWp+6rjnviOsCET8I/n9wldHylg0huW1by0E3u0gNQEqkK5PdyGLbRLdwgmnF2/iGShzFVfaPk0qGAHd6o8wuDhT31o2s6CPYgW5hmz7WffK/ezWSWDDEteBdCe57z4bXBzVqueMbHmBCmqR8Vhn80NU7f1ZTtiG8IflTZj/NhFx/zaMEP39U3/lh8cQcQ26oJ9m0MVneycx/iq9ojYCTjoeVia2vpdVMBtWMR/b124BJsfisvkT+WF1K4F+z/KKRCzq5E2M+DEijsKgTRAD1OOh+tJtL6tPuEE+uaU/K5SdKTPCCTE5USNXSVGCHFaPG4m9SL8ydz7Dk+FkXOxN1i/5qSRjaR616lbRGWLbnymM8dRsMnDN3yu3FVPj2EwwH3xqXEB0GpaQ+TLihOWhTP+CFxY675NZbggrnlvBlTNqahENVv+wOlKAVwm+YS8c6YLmluD/Kq18it5WbELVp3OQW/bf9tKtMYy4OaNa2jD++KQXVSwP6DINE3o6JRBILiDU7YtosgtFOaOfN8eNdI4CZxRUSC6HmxLZGvwHa4hCxP3Lauz3S5bbUk+0REMtR9RHLSk2iDCIIxKgOzXIv1krpc73GQ== Storm_FireFox1 (GPG:2FB5275E)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/otR1RU2NB+ms53TTdgtOj5aEFXeuBExvAvr/F9NQN Storm_FireFox1 (ServerCat)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwkUBJcKSbuM66RqfYzfJjV7wfbXjh4PoaBzKhWRXpO Storm_FireFox1 (Prompt)"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPgMul7XW0LoM3ADHGLu/Tkn+XQGKRD+gtcHxiW3IAn Storm_FireFox1 (Bullshit Machine)"
    ];
  };
}
