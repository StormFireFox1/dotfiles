set shell := ["bash", "-euo", "pipefail", "-c"]

# Niks3 client settings; override by exporting these in your shell.
export NIKS3_SERVER_URL := env("NIKS3_SERVER_URL", "https://cache.nix.matei.lol")
export NIKS3_AUTH_TOKEN_FILE := env("NIKS3_AUTH_TOKEN_FILE")

# Every configuration as `<kind>:<flake attr name>:<system>`.
# The system gates which machine can realize it (see `emulated` below).
configs := """
nixos:BullshitMachine:x86_64-linux
nixos:RescueUSB:x86_64-linux
nixos:Kaos:aarch64-linux
nixos:KaosImage:aarch64-linux
hm:ghost@BullshitMachine:x86_64-linux
hm:ghost@StormPrism:aarch64-darwin
nix-darwin:StormPrism:aarch64-darwin
"""

# Set variable for extra systems current one can build.
emulated := env("JUST_EMULATED_SYSTEMS", if os() == "linux" { "aarch64-linux" } else { "" })

# List recipes (first recipe, so bare `just` shows this)
default:
    @just --list

# List configurations and whether this machine can build them
list:
    #!/usr/bin/env bash
    set -euo pipefail
    printf '%-10s %-26s %-16s %s\n' KIND NAME SYSTEM BUILDABLE
    mapfile -t rows <<< "{{configs}}"
    for row in "${rows[@]}"; do
      if [[ -z "$row" ]]; then
        continue
      fi
      IFS=: read -r kind name _system <<< "$row"
      just _cfg check "$kind" "$name"
    done

# Build a configuration (nixos | hm | nix-darwin) and print its store path
[arg("kind", help="nixos | hm | nix-darwin")]
[arg("name", help="configuration name (see: just list)")]
build kind name:
    @just _cfg build "{{kind}}" "{{name}}"

# Build a configuration, push its closure to Niks3 and (re)create its pin
[arg("kind", help="nixos | hm | nix-darwin")]
[arg("name", help="configuration name (see: just list)")]
push kind name:
    @just _cfg push "{{kind}}" "{{name}}"

# Build every configuration available on this machine, printing store paths
build-all: (_all "build")

# Build, push and pin every configuration available on this machine
push-all: (_all "push")

# Resolve <kind> <name>, verify it is buildable here, then build it. For
# mode=push also upload the closure and refresh the <kind>-<name> pin.
[private]
_cfg mode kind name skip="false":
    #!/usr/bin/env bash
    set -euo pipefail

    case "{{kind}}" in
      nixos)      attr="nixosConfigurations.{{name}}.config.system.build.toplevel" ;;
      hm)         attr="homeConfigurations.\"{{name}}\".activationPackage" ;;
      nix-darwin) attr="darwinConfigurations.{{name}}.system" ;;
      *)          echo "unknown kind '{{kind}}' (want nixos, hm or nix-darwin; see: just list)" >&2; exit 2 ;;
    esac

    system=""
    mapfile -t rows <<< "{{configs}}"
    for row in "${rows[@]}"; do
      if [[ -z "$row" ]]; then
        continue
      fi
      IFS=: read -r k n s <<< "$row"
      if [[ "$k" == "{{kind}}" && "$n" == "{{name}}" ]]; then
        system="$s"
      fi
    done
    if [[ -z "$system" ]]; then
      echo "unknown config '{{kind}}/{{name}}' (see: just list)" >&2
      exit 2
    fi

    current=$(nix eval --impure --raw --expr builtins.currentSystem)
    buildable=no
    if [[ "$system" == "$current" ]]; then
      buildable=yes
    fi
    for e in {{emulated}}; do
      if [[ "$system" == "$e" ]]; then
        buildable=yes
      fi
    done

    if [[ "{{mode}}" == "check" ]]; then
      printf '%-10s %-26s %-16s %s\n' "{{kind}}" "{{name}}" "$system" "$buildable"
      exit 0
    fi

    if [[ "$buildable" != yes ]]; then
      if [[ "{{skip}}" == "true" ]]; then
        echo ">>> skip {{kind}}/{{name}} ($system; this machine is $current)" >&2
        exit 0
      fi
      echo "{{kind}}/{{name}} is $system, not buildable on $current." >&2
      echo "Set JUST_EMULATED_SYSTEMS=\"$system\" if this machine can emulate it." >&2
      exit 2
    fi

    echo ">>> {{mode}} {{kind}}/{{name}}" >&2
    out=$(nix build --no-link --print-out-paths ".#$attr")
    [[ -n "$out" ]] || { echo "no store path produced for $attr" >&2; exit 1; }
    mapfile -t paths <<< "$out"

    if [[ "{{mode}}" == "push" ]]; then
      niks3 push "${paths[@]}" >&2
      pin="{{kind}}-{{name}}"
      if niks3 pins list --names-only 2>/dev/null | grep -qxF "$pin"; then
        niks3 pins delete "$pin" >&2
      fi
      niks3 pins create "$pin" "${paths[0]}" >&2
      echo ">>> pinned $pin -> ${paths[0]}" >&2
    fi

    printf '%s\n' "${paths[@]}"

# Run <mode> over every config; _cfg decides what this machine can build.
[private]
_all mode:
    #!/usr/bin/env bash
    set -euo pipefail
    mapfile -t rows <<< "{{configs}}"
    for row in "${rows[@]}"; do
      if [[ -z "$row" ]]; then
        continue
      fi
      IFS=: read -r kind name _system <<< "$row"
      just _cfg "{{mode}}" "$kind" "$name" true
    done
