FROM alpine:latest

RUN apk add --no-cache --update curl iptables bash && \
    curl -L https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz --output udp2raw.tar.gz && \
    mkdir -p /udp2raw && \
    tar -zxvf udp2raw.tar.gz -C /udp2raw && \
    rm -f udp2raw.tar.gz

COPY ./entrypoint.sh /entrypoint.sh

ENV LOCALADDR=127.0.0.1
ENV LOCALPORT=1080
ENV REMOTEADDR=127.0.0.1
ENV REMOTEPORT=1080
ENV KEY=k3yP4ssw0rd
ENV MODE=server

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]