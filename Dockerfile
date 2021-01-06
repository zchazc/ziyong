FROM golang:alpine AS builder
WORKDIR /
RUN apk add git make &&\
    git clone https://github.com/zchazc/ziyong.git &&\
    cd ziyong &&\
    make &&\
    wget https://github.com/v2ray/domain-list-community/raw/release/dlc.dat -O build/geosite.dat &&\
    wget https://github.com/v2ray/geoip/raw/release/geoip.dat -O build/geoip.dat

FROM alpine
WORKDIR /
COPY --from=builder /ziyong/build /usr/local/bin/
COPY --from=builder /ziyong/example/server.json /etc/trojan-go/config.json

ENTRYPOINT ["/usr/local/bin/trojan-go", "-config"]
CMD ["/etc/trojan-go/config.json"]
