#!/usr/bin/env bash

set -euo pipefail

if ! command -v ifconfig >/dev/null 2>&1; then
    sudo apt-get update -qq >/dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq net-tools >/dev/null 2>&1
fi

local_ip="$(
    ifconfig 2>/dev/null |
        awk '
            /^[[:alnum:]][[:alnum:]_.:-]*:/ {
                interface = $1
                sub(/:$/, "", interface)
            }
            interface != "lo" && $1 == "inet" && $2 != "127.0.0.1" {
                print $2
                exit
            }
        '
)"

if [[ -n "$local_ip" ]]; then
    printf '%s\n' "$local_ip"
else
    exit 1
fi