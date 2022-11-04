# A docker file for scripts/make/build-docker.sh.
FROM docker.io/library/node:18.12.0-alpine@sha256:ccd756ecfba8272d6638b0a39f2a2f175b4a3c03f2f045be1c5a9d29914fbc0e as build_adwireguard

ARG WG_PATH
ARG DIST_DIR

# Update certificates.
# RUN mkdir -p /opt/adwireguard && \
# 	mkdir -p /opt/adwireguard/conf /opt/adwireguard/work && \
# 	chown -R nobody: /opt/adwireguard

COPY ${DIST_DIR}/${WG_PATH}/ /opt/adwireguard/

WORKDIR /opt/adwireguard

RUN npm ci --production

FROM docker.io/library/node:18.12.0-alpine@sha256:ccd756ecfba8272d6638b0a39f2a2f175b4a3c03f2f045be1c5a9d29914fbc0e

ARG DIST_DIR
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

COPY --from=build_adwireguard /opt/adwireguard /opt/adwireguard
RUN mv /opt/adwireguard/node_modules /node_modules

WORKDIR /opt/adwireguard

# Enable this to run `npm run serve`
RUN npm i -g nodemon

COPY \
	${DIST_DIR}/AdGuardHome_${TARGETOS}_${TARGETARCH}_${TARGETVARIANT}\
	/opt/adwireguard/AdGuardHome

COPY \
	${DIST_DIR}/entrypoint.sh /opt/adwireguard/entrypoint.sh

RUN apk --no-cache add ca-certificates tzdata \
  	wireguard-tools wget curl libcap bind-tools dumb-init && \
  	mkdir -p /opt/adwireguard/conf /opt/adwireguard/work
	# chown -R nobody: /opt/adwireguard

RUN setcap 'cap_net_bind_service=+eip' /opt/adwireguard/AdGuardHome
#RUN chmod 755 entrypoint.sh

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 784    :      UDP : DNS-over-QUIC (experimental)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 3001   : TCP, UDP : HTTP(S) (beta, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)
# 8853   :      UDP : DNS-over-QUIC (experimental)
# Wireguard-Easy Ports
# 51820  :      UDP : WireGuard Port
# 51821  :      TCP : wg-easy WebUI Port

EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 784/udp\
	853/tcp 853/udp 3000/tcp 3000/udp 3001/tcp 3001/udp 5443/tcp\
	5443/udp 6060/tcp 8853/udp 51820/udp 51821/tcp

# Set Environment
ENV DEBUG=Server,AdWireGuard

# Run AdGuard and wg-easy
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash", "/opt/adwireguard/entrypoint.sh"]
