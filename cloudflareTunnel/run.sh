#!/usr/bin/with-contenv bashio

TUNNEL_NAME="$(bashio::config 'tunnelName')"
LOCAL_URL="$(bashio::config 'localUrl')"
HOSTNAME="$(bashio::config 'hostname')"
CONFIG_DIR="/data"
CONFIG_FILE=${CONFIG_DIR}/config.yml
TUNNEL_ORIGIN_CERT=${CONFIG_DIR}/cert.pem

bashio::log.info ls /root/.cloudflared/cert.pem
ls /root/.cloudflared/cert.pem || bashio::log.info 'ls failed'

bashio::log.info ls ${TUNNEL_ORIGIN_CERT}
ls ${TUNNEL_ORIGIN_CERT} || bashio::log.info 'ls failed'

if ! bashio::fs.file_exists ${TUNNEL_ORIGIN_CERT} ; then
    bashio::log.info "Cert file does not exists. Logging in."
    cloudflared tunnel login
    bashio::log.info "Logged in, cleanup pre-existing tunnels."
    cloudflared tunnel cleanup ${TUNNEL_NAME}
    bashio::log.info "Deleting pre-existing tunnels."
    cloudflared tunnel delete ${TUNNEL_NAME}
    bashio::log.info "Tunnel ${TUNNEL_NAME} deleted."

    bashio::log.info "Backup Cloudflared cert file to persistent volume"
    cp /root/.cloudflared/cert.pem ${TUNNEL_ORIGIN_CERT}
else
    bashio::log.info "Getting Cloudflared cert file from persistent volume"
    mkdir -p /root/.cloudflared
    cp ${TUNNEL_ORIGIN_CERT} /root/.cloudflared/cert.pem
fi

cloudflared tunnel --config ${CONFIG_FILE} --name ${TUNNEL_NAME}  --url ${LOCAL_URL} --hostname ${HOSTNAME} --overwrite-dns
