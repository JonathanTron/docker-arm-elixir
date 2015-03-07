#!/bin/bash
set -e
source /build/buildconfig
set -x

## Remove compile dependencies
pacman -Rs --noconfirm git gcc make
pacman -Scc --noconfirm
rm -rf /var/lib/pacman/sync/*

rm -rf /build
rm -rf /tmp/* /var/tmp/*
