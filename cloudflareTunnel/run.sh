#!/usr/bin/with-contenv bashio

TUNNEL_NAME="$(bashio::config 'tunnelName')"
LOCAL_URL="$(bashio::config 'localUrl')"
HOSTNAME="$(bashio::config 'hostname')"

if [ ! -f "/root/.cloudflared/cert.pem" ]; then
    cloudflared tunnel login
    cloudflared tunnel delete ${TUNNEL_NAME}
fi

cloudflared tunnel --name ${TUNNEL_NAME}  --url ${LOCAL_URL} --hostname ${HOSTNAME}
