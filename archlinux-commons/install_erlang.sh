#!/bin/bash
set -e
source /build/buildconfig.sh
set -x

## Install erlang headless
pacman -S --noconfirm --noprogressbar erlang-nox
