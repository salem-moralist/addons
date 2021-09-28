#!/usr/bin/with-contenv bashio

TUNNEL_NAME="$(bashio::config 'tunnelName')"
LOCAL_URL="$(bashio::config 'localUrl')"
HOSTNAME="$(bashio::config 'hostname')"



if [ ! -f "/root/.cloudflared/cert.pem" ]; then
    echo "Cert file does not exists. Logging in."
    cloudflared tunnel login
    echo "Logged in, cleanup pre-existing tunnels."
    cloudflared tunnel cleanup ${TUNNEL_NAME}
    echo "Deleting pre-existing tunnels."
    cloudflared tunnel delete ${TUNNEL_NAME}
    echo "Tunnel ${TUNNEL_NAME} deleted."
fi

cloudflared tunnel --name ${TUNNEL_NAME}  --url ${LOCAL_URL} --hostname ${HOSTNAME}
