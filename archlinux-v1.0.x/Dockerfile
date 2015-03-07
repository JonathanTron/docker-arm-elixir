FROM armv7/armhf-archlinux:2015-02
MAINTAINER Jonathan Tron <jonathan@tron.name>

ENV HOME /root
ADD . /build

RUN /build/prepare.sh && \
    /build/install_erlang.sh && \
    /build/install_elixir.sh && \
    /build/cleanup.sh
