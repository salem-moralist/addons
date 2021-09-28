#!/usr/bin/with-contenv bashio

TUNNEL_NAME="$(bashio::config 'tunnelName')"
LOCAL_URL="$(bashio::config 'localUrl')"
HOSTNAME="$(bashio::config 'hostname')"
CONFIG_DIR="data/config.yml"


bashio::log.info ls /root/.cloudflared/cert.pem
ls /root/.cloudflared/cert.pem || bashio::log.info 'ls failed'


if [ ! bashio::fs.file_exists "/root/.cloudflared/cert.pem" ]; then
    bashio::log.info "Cert file does not exists. Logging in."
    cloudflared tunnel login
    bashio::log.info "Logged in, cleanup pre-existing tunnels."
    cloudflared tunnel cleanup ${TUNNEL_NAME}
    bashio::log.info "Deleting pre-existing tunnels."
    cloudflared tunnel delete ${TUNNEL_NAME}
    bashio::log.info "Tunnel ${TUNNEL_NAME} deleted."
fi

cloudflared tunnel --config ${CONFIG_DIR} --name ${TUNNEL_NAME}  --url ${LOCAL_URL} --hostname ${HOSTNAME} ----overwrite-dns
