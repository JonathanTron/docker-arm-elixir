#!/bin/bash
set -e
source /build/buildconfig.sh
set -x

## Remove compile dependencies
pacman -Rs --noconfirm --noprogressbar git gcc make
pacman -Scc --noconfirm --noprogressbar
rm -rf /var/lib/pacman/sync/*
rm -rf /var/cache/pacman/pkg/*

rm -rf /build
rm -rf /tmp/* /var/tmp/*

rm -f /usr/bin/qemu-arm-static /usr/bin/qemu-arm-static-wrap
