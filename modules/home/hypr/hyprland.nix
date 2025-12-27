{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.fireflake.hypr;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun --allow-images";
        monitor = [
          "DP-3,2560x1440@144,0x0,1"
          "HDMI-A-2,2560x1440@144,2560x0,1"
          "DP-1,disable"
        ];
        exec-once = [
          "ashell"
          "hyprpaper"
        ];
        env = [
          "XCURSOR_SIZE,18"
          "HYPRCURSOR_SIZE,18"
        ];
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          resize_on_border = true;
          allow_tearing = false;
          layout = "dwindle";
          "col.active_border" = "$red $peach 45deg";
        };
        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        animations = {
          enabled = true;
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          new_status = "master";
        };
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = true;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };
        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, W, killactive,"
          "$mod, F, fullscreen,"
          "$mod SHIFT, Q, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, P, pseudo, # dwindle"
          "$mod SHIFT, P, togglesplit, # dwindle"
          # Move focus with mod + h/j/k/l
          # Arrow keys also work.
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          # Move window within workspace with mod + SHIFT + h/j/k/l/arrows
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          # Scratchpad space with mod + S
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          # Lock the screen
          "$mod CTRL, q, exec, hyprlock"
        ]
        # Switch workspaces with mod + [0-9]
        # Move active window to a workspace with mod + SHIFT + [0-9]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          ) 9
        ));
        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
        windowrulev2 = [
          # Ignore maximize requests from apps. You'll probably like this.
          "suppressevent maximize, class:.*"
          # Fix some dragging issues with XWayland
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          # Fix dragging with FL Studio
          "nofocus, class:^(FL64.exe)$, title:^()$"
          "noinitialfocus, xwayland:1"
        ];
      };
    };
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
