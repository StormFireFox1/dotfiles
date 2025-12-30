{
  lib,
  pkgs,
  config,
  ...
}:
let
  movementKeys = {
    "h" = "left";
    "j" = "down";
    "k" = "up";
    "l" = "right";
  };
  workspaces = builtins.map toString (lib.lists.range 1 9);
in
{
  services.aerospace = {
    enable = true;
    settings = {
      config-version = 2;
      persistent-workspaces = workspaces;
      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };
      mode.main.binding =
        builtins.listToAttrs (
          builtins.map (key: {
            name = "alt-${key}";
            value = "focus ${movementKeys.${key}}";
          }) (builtins.attrNames movementKeys)
        )
        // builtins.listToAttrs (
          builtins.map (key: {
            name = "alt-shift-${key}";
            value = "move ${movementKeys.${key}}";
          }) (builtins.attrNames movementKeys)
        )
        // builtins.listToAttrs (
          builtins.map (workspace: {
            name = "alt-shift-${workspace}";
            value = "move-node-to-workspace ${workspace}";
          }) workspaces
        )
        // {
          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        };
    };
  };
}
