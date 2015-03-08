#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install erlang headless
pacman -S --noconfirm --noprogressbar erlang-nox
