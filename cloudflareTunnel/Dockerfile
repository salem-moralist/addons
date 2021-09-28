ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache libc6-compat curl

#RUN go get github.com/cloudflare/cloudflared/cmd/cloudflared

RUN curl -sL -O https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 && mv cloudflared-linux-arm64 /usr/local/bin/cloudflared &&  chmod +x /usr/local/bin/cloudflared

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]