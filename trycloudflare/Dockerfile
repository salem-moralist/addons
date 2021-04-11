ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add go git gcc libc-dev

RUN go get github.com/cloudflare/cloudflared/cmd/cloudflared
RUN mv /root/go/bin/cloudflared /usr/local/bin/cloudflared
RUN chmod +x /usr/local/bin/cloudflared

CMD ["sh", "-c", "cloudfalred tunnel --url $(bashio::config 'url')"]

