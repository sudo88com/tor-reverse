# syntax=docker/dockerfile:1

FROM debian:buster as base

FROM base

RUN apt-get update && \
    apt-get -y install \
    nginx \
    tor torsocks ntpdate \
    sudo \
    gcc libsodium-dev make autoconf && \
    rm -rf /var/lib/apt/lists/*

ADD app/mkp224o /mkp224o
RUN cd /mkp224o && \
    chmod +x *.sh && \
    ./autogen.sh && \
    ./configure && \
    make && \
    mv ./mkp224o /bin && \
    cd / && \
    rm -rf /mkp224o && \
    apt-get -y purge gcc libsodium-dev make autoconf

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin hidden

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY app/main.sh /main.sh
RUN chmod +x /main.sh

COPY app/torrc /etc/tor/torrc

COPY app/nginx.conf /etc/nginx/nginx.conf

VOLUME /web
WORKDIR /web

EXPOSE 9050
ENTRYPOINT ["/main.sh"]
CMD ["serve"]
