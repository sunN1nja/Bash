#!/usr/bin/env bash

if ! command -v ifconfig >/dev/null 2>&1; then
    sudo apt-get update -qq >/dev/null 2>&1
    sudo apt-get install -y -qq net-tools >/dev/null 2>&1
fi

ifconfig 2>/dev/null |
awk '
    $1 == "inet" {
        ip = $2
        sub(/^addr:/, "", ip)

        if (ip != "127.0.0.1") {
            print ip
            exit
        }
    }
'