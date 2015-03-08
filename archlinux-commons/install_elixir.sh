#!/bin/bash
set -e
source /build/buildconfig.sh
set -x

## Install elixir build dependencies
pacman -S --noconfirm --noprogressbar git gcc make

cd /build
## Grab and extract elixir source
curl -L -o v1.0.3.tar.gz https://github.com/elixir-lang/elixir/archive/v1.0.3.tar.gz
tar xzf v1.0.3.tar.gz

## Compile, run tests and install elixir
cd elixir-1.0.3
make clean test && make install
