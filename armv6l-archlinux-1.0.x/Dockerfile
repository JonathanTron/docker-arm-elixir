FROM digitallyseamless/archlinux-armv6:2014.12.15-2
MAINTAINER Jonathan Tron <jonathan@tron.name>

ENV HOME /root
ADD . /build

RUN /build/prepare.sh && \
    /build/install_erlang.sh && \
    /build/install_elixir.sh && \
    /build/cleanup.sh

# Elixir don't behave correctly when locale is not UTF-8
ENV LANG en_US.UTF-8
