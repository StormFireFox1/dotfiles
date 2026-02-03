{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.fireflake.programs;
  isDarwin = pkgs.stdenv.isDarwin;
  tailscaleHosts = [
    { name = "stormdrive"; user = "Storm_FireFox1"; port = 31187; }
    { name = "bullshitmachine"; }
    { name = "gatekeeper"; }
    { name = "homander"; }
    { name = "jonkler"; }
    { name = "man"; }
  ];

  mkTailscaleHost = { name, user ? "ghost", port ? null }: {
    inherit name;
    value = {
      inherit user;
      hostname = "${name}.bobcat-gopher.ts.net";
      forwardAgent = true;
    } // lib.optionalAttrs (port != null) { inherit port; };
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = builtins.listToAttrs (map mkTailscaleHost tailscaleHosts)
      // {
        "*" = {
          extraOptions = lib.mkIf isDarwin {
            IdentityAgent = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
          };
        };
        "ns" = {
          user = "rares";
          hostname = "ns1.gard.us";
          proxyJump = "node1";
        };
        "node1" = {
          user = "rares";
          hostname = "217.156.97.37";
          port = 31187;
          forwardAgent = true;
        };
        "router" = {
          user = "matei";
          hostname = "172.16.90.1";
          port = 31187;
        };
      };
    };
    services.ssh-agent.enable = true;
  };
}