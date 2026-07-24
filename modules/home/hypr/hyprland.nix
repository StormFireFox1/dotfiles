{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.fireflake.hypr;
  lua = lib.generators.mkLuaInline;
  mainMod = "SUPER";
  convertToHyprEnv = envList: map (env: { _args = lib.strings.splitString "=" env; }) envList;
  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    fullscreen = lua "hl.dsp.window.fullscreen()";
    float = lua "hl.dsp.window.float()";
  };
  noctaliaIpc = cmd: "noctalia msg ${cmd}";
  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };
  bindm = keys: dispatcher: {
    _args = [
      keys
      dispatcher
      (lua "{ mouse = true }")
    ];
  };
  bindl = keys: dispatcher: {
    _args = [
      keys
      dispatcher
      (lua "{ locked = true }")
    ];
  };
  startups =
    appList:
    lua ''
      function()
      ${lib.strings.concatLines (map (app: ''hl.exec_cmd("${app}")'') appList)}      
      end
    '';
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slurp
      grim
      wl-clipboard
    ];
    # Screenshot utility.
    home.file.".local/bin/wl-screencap-shortcut" = {
      enable = true;
      executable = true;
      text = ''
        #!/usr/bin/env bash
        slurp | grim -g - - | tee ~/Pictures/Screeenshots/$(date +%s).png | wl-copy
      '';
    };
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      settings = {
        on = {
          _args = [
            "hyprland.start"
            (startups (
              if cfg.shellType == "noctalia" then
                [ "noctalia" ]
              else
                [
                  "ashell"
                  "hyprpaper"
                  "vicinae server"
                ]
            ))
          ];
        };
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            resize_on_border = true;
            allow_tearing = false;
            layout = "dwindle";
            "col.active_border" = {
              colors = [
                "rgba(00f38ba8)"
                "rgba(00fab387)"
              ];
              angle = 45;
            };
          };
          decoration = {
            rounding = 20;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "0xee1a1a1a";
            };
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };
          dwindle = {
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
        };
        monitor = [
          {
            output = "DP-4";
            mode = "2560x1440@144";
            position = "0x0";
            scale = "1";
          }
          {
            output = "DP-3";
            mode = "2560x1440@144";
            position = "2560x0";
            scale = "1";
          }
          {
            output = "HDMI-A-2";
            disabled = true;
          }
        ];
        # Persist 10 workspaces, 5 on the left, 5 in the middle.
        workspace_rule = builtins.concatLists (
          builtins.genList (i: [
            {
              workspace = "${toString (i + 1)}";
              monitor = "DP-3";
              persistent = true;
            }
            {
              workspace = "${toString (i + 6)}";
              monitor = "DP-4";
              persistent = true;
            }
          ]) 5
        );
        env = convertToHyprEnv [
          "XCURSOR_SIZE=18"
          "HYPRCURSOR_SIZE=18"
        ];
        curve =
          lib.attrsets.mapAttrsToList
            (curveType: props: {
              _args = [
                curveType
                props
              ];
            })
            {
              easeOutQuint = {
                type = "bezier";
                points = [
                  [
                    0.23
                    1
                  ]
                  [
                    0.32
                    1
                  ]
                ];
              };
              easeInOutCubic = {
                type = "bezier";
                points = [
                  [
                    0.65
                    0.05
                  ]
                  [
                    0.36
                    1
                  ]
                ];
              };
              linear = {
                type = "bezier";
                points = [
                  [
                    0
                    0
                  ]
                  [
                    1
                    1
                  ]
                ];
              };
              almostLinear = {
                type = "bezier";
                points = [
                  [
                    0.5
                    0.5
                  ]
                  [
                    0.75
                    1
                  ]
                ];
              };
              quick = {
                type = "bezier";
                points = [
                  [
                    0.15
                    0
                  ]
                  [
                    0.1
                    1
                  ]
                ];
              };
              easy = {
                type = "spring";
                mass = 1;
                stiffness = 71.2633;
                dampening = 15.8273644;
              };
            };
        animation = [
          {
            leaf = "global";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 5.39;
            bezier = "easeOutQuint";
          }
          {
            leaf = "windows";
            enabled = true;
            speed = 4.79;
            spring = "easy";
          }
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 1;
            spring = "easy";
            style = "popin 87%";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 1;
            bezier = "linear";
            style = "popin 87%";
          }
          {
            leaf = "fadeIn";
            enabled = true;
            speed = 1.73;
            bezier = "almostLinear";
          }
          {
            leaf = "fadeOut";
            enabled = true;
            speed = 1.46;
            bezier = "almostLinear";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 3.03;
            bezier = "quick";
          }
          {
            leaf = "layers";
            enabled = true;
            speed = 3.81;
            bezier = "easeOutQuint";
          }
          {
            leaf = "layersIn";
            enabled = true;
            speed = 4;
            bezier = "easeOutQuint";
            style = "fade";
          }
          {
            leaf = "layersOut";
            enabled = true;
            speed = 1.5;
            bezier = "linear";
            style = "fade";
          }
          {
            leaf = "fadeLayersIn";
            enabled = true;
            speed = 1.79;
            bezier = "almostLinear";
          }
          {
            leaf = "fadeLayersOut";
            enabled = true;
            speed = 1.39;
            bezier = "almostLinear";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 1.94;
            bezier = "almostLinear";
            style = "fade";
          }
          {
            leaf = "workspacesIn";
            enabled = true;
            speed = 1.21;
            bezier = "almostLinear";
            style = "fade";
          }
          {
            leaf = "workspacesOut";
            enabled = true;
            speed = 1.94;
            bezier = "almostLinear";
            style = "fade";
          }
          {
            leaf = "zoomFactor";
            enabled = true;
            speed = 7;
            bezier = "quick";
          }
        ];
        bind =
          (
            if cfg.shellType == "hypr" then
              [
                (bind "${mainMod} + Space" (dsp.exec "vicinae toggle"))
                # Lock the screen
                (bind "${mainMod} + CTRL + Q" (dsp.exec "hyprlock"))
              ]
            else
              [
                (bind "${mainMod} + Space" (dsp.exec (noctaliaIpc "panel-toggle launcher")))
                (bind "${mainMod} + S" (dsp.exec (noctaliaIpc "panel-toggle control-center")))
                (bind "${mainMod} + comma" (dsp.exec (noctaliaIpc "settings-toggle")))
                (bind "${mainMod} + CTRL + Q" (dsp.exec (noctaliaIpc "session lock")))
                (bind "${mainMod} + CTRL + Space" (dsp.exec (noctaliaIpc "panel-toggle launcher /emo")))
                (bind "${mainMod} + CTRL + C" (dsp.exec (noctaliaIpc "panel-toggle clipboard")))

                (bind "XF86AudioRaiseVolume" (dsp.exec (noctaliaIpc "volume-up")))
                (bind "XF86AudioLowerVolume" (dsp.exec (noctaliaIpc "volume-down")))
                (bind "XF86AudioMute" (dsp.exec (noctaliaIpc "volume-mute")))
                (bind "XF86MonBrightnessUp" (dsp.exec (noctaliaIpc "brightness-up")))
                (bind "XF86MonBrightnessDown" (dsp.exec (noctaliaIpc "brightness-down")))
              ]
          )
          ++ [
            (bind "${mainMod} + W" dsp.close)
            (bind "${mainMod} + F" dsp.fullscreen)
            (bind "${mainMod} + V" dsp.float)
            (bind "${mainMod} + Return" (dsp.exec "kitty"))
            (bind "${mainMod} + SHIFT + Q" (dsp.exec "hyprshutdown"))
            (bind "${mainMod} + E" (dsp.exec "dolphin"))
            (bind "${mainMod} + SHIFT + x" (dsp.exec (noctaliaIpc "screenshot-region")))
            # Move focus with mod + h/j/k/l
            # Arrow keys also work.
            (bind "${mainMod} + H" (lua ''hl.dsp.focus({ direction = "l" })''))
            (bind "${mainMod} + L" (lua ''hl.dsp.focus({ direction = "r" })''))
            (bind "${mainMod} + K" (lua ''hl.dsp.focus({ direction = "u" })''))
            (bind "${mainMod} + J" (lua ''hl.dsp.focus({ direction = "d" })''))
            (bind "${mainMod} + left" (lua ''hl.dsp.focus({ direction = "l" })''))
            (bind "${mainMod} + right" (lua ''hl.dsp.focus({ direction = "r" })''))
            (bind "${mainMod} + up" (lua ''hl.dsp.focus({ direction = "u" })''))
            (bind "${mainMod} + down" (lua ''hl.dsp.focus({ direction = "d" })''))
            # Move window within workspace with mod + SHIFT + h/j/k/l/arrows
            (bind "${mainMod} + SHIFT + H" (lua ''hl.dsp.window.move({ direction = "l" })''))
            (bind "${mainMod} + SHIFT + L" (lua ''hl.dsp.window.move({ direction = "r" })''))
            (bind "${mainMod} + SHIFT + K" (lua ''hl.dsp.window.move({ direction = "u" })''))
            (bind "${mainMod} + SHIFT + J" (lua ''hl.dsp.window.move({ direction = "d" })''))
            (bind "${mainMod} + left" (lua ''hl.dsp.window.move({ direction = "l" })''))
            (bind "${mainMod} + right" (lua ''hl.dsp.window.move({ direction = "r" })''))
            (bind "${mainMod} + up" (lua ''hl.dsp.window.move({ direction = "u" })''))
            (bind "${mainMod} + down" (lua ''hl.dsp.window.move({ direction = "d" })''))
            # Scroll through existing workspaces with mod + scroll
            (bind "${mainMod} + mouse_down" (lua ''hl.dsp.focus({ workspace = "e+1" })''))
            (bind "${mainMod} + mouse_up" (lua ''hl.dsp.focus({ workspace = "e-1" })''))
            # Move/resize windows with mainMod + LMB/RMB and dragging
            (bindm "${mainMod} + mouse:272" (lua "hl.dsp.window.drag()"))
            (bindm "${mainMod} + mouse:273" (lua "hl.dsp.window.resize()"))
            (bindl "XF86AudioPrev" (dsp.exec "playerctl previous"))
            (bindl "XF86AudioNext" (dsp.exec "playerctl next"))
            (bindl "XF86AudioPause" (dsp.exec "playerctl play-pause"))
            (bindl "XF86AudioPlay" (dsp.exec "playerctl play-pause"))
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
                (bind "${mainMod} + code:1${toString i}" (lua "hl.dsp.focus({ workspace = ${toString ws}})"))
                (bind "${mainMod} + SHIFT + code:1${toString i}" (
                  lua "hl.dsp.window.move({ workspace = ${toString ws}, follow = false})"
                ))
              ]
            ) 10
          ));
        layer_rule =
          if (cfg.shellType == "hypr") then
            [
              {
                name = "vicinae-enable-blur";
                match = {
                  namespace = "vicinae";
                };
                blur = true;
                ignore_alpha = 0;
              }
              {
                name = "vicinae-disable-animations";
                match = {
                  namespace = "vicinae";
                };
                no_anim = true;
              }
            ]
          else
            [
              {
                name = "noctalia";
                match = {
                  namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
                };
                no_anim = true;
                ignore_alpha = 0.5;
                blur = true;
                blur_popups = true;
              }
            ];
        window_rule =
          (
            if cfg.shellType == "noctalia" then
              [
                {
                  match = {
                    class = "dev.noctalia.Noctalia";
                  };
                  float = true;
                  size = [
                    1080
                    920
                  ];
                }
              ]
            else
              [ ]
          )
          ++ [
            # Ignore maximize requests from apps.
            {
              match = {
                class = ".*";
              };
              suppress_event = "maximize";
            }
            # Fix some dragging issues with XWayland
            {
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };
              no_focus = true;
            }
            # Fix dragging with FL Studio.
            {
              match = {
                class = "^(FL64.exe)$";
                title = "^()$";
              };
              no_focus = true;
            }
            {
              match = {
                xwayland = true;
              };
              no_initial_focus = true;
            }

          ]
          ++ (
            if cfg.shellType == "hypr" then
              [
                {
                  match = {
                    class = "flameshot";
                    title = "flameshot";
                  };
                  move = "0 0";
                  float = true;
                  pin = true;
                  fullscreen_state = "0 2";
                }
              ]
            else
              [ ]
          );
      };
    };
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
