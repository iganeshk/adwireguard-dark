# AdWireGuard

[![Build AdguardHome Dark](https://github.com/iganeshk/adwireguard-dark/actions/workflows/build.yml/badge.svg)](https://github.com/iganeshk/adwireguard-dark/actions/workflows/build.yml)
[![Build AdguardHome Dark](https://github.com/iganeshk/adwireguard-dark/actions/workflows/nightly.yml/badge.svg)](https://github.com/iganeshk/adwireguard-dark/actions/workflows/nightly.yml)
[![Build & Docker Workflow](https://img.shields.io/github/v/release/iganeshk/adwireguard-dark.svg?include_prereleases)](https://github.com/iganeshk/adwireguard-dark/releases)

<p align="center">
  <img src="https://raw.githubusercontent.com/iganeshk/adwireguard-dark/assets/screenshot-adwireguard.png?v1" width="800px" alt="AdWireGuard Screenshot" />
</p>

[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome/) and [wg-easy](https://github.com/WeeJeWel/wg-easy) images built from sources with Dark theme (patches applied on build) for linux - amd64, arm64 & arm6/7 platforms

This allows you monitor wireguard clients with adguard home, allowing to setup client specific configuration 

*Note: On Android, make sure PrivateDNS is disabled to avoid DNS leaking*

## Docker Images & Releases

#### AdWireGuard Dark (AdGuardHome + wg-easy)
* [Docker Hub](https://hub.docker.com/r/iganesh/adwireguard-dark)
* [ghcr.io](https://github.com/iganeshk/adwireguard-dark/pkgs/container/adwireguard-dark)

#### AdGuardHome Dark
* [Docker Hub](https://hub.docker.com/r/iganesh/adwireguard-dark)
* [ghcr.io](https://github.com/iganeshk/adwireguard-dark/pkgs/container/adwireguard-dark)

#### AdGuardHome Dark Binaries

* [Releases](https://github.com/iganeshk/adwireguard-dark/releases)

### Docker-Compose AdWireGuard:
```
version: "3.8"

services:
  adwireguard:
    container_name: adwireguard
    # image: ghcr.io/iganeshk/adwireguard-dark:latest
    image: iganesh/adwireguard-dark:latest
    restart: unless-stopped
    ports:
      - '53:53'           # AdGuardHome DNS Port
      - '3000:3000'       # Default Address AdGuardHome WebUI
      - '853:853'         # DNS-TLS
      - '51820:51820/udp' # wiregaurd port
      - '51821:51821/tcp' # wg-easy webUI
    environment:
        # WG-EASY ENVS
      - WG_HOST= ** HOST-IP **
      - PASSWORD=changeIt
      - WG_PORT=51820
      - WG_DEFAULT_ADDRESS=10.10.11.x
      - WG_DEFAULT_DNS=10.10.10.2
      - WG_MTU=1420
    volumes:
        # adguard-home volume
      - './adguard/work:/opt/adwireguard/work'
      - './adguard/conf:/opt/adwireguard/conf'
        # wg-easy volume
      - './wireguard:/etc/wireguard'
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv6.conf.all.disable_ipv6=1    # Disable IPv6
    networks:
      vpn_net:
        ipv4_address: 10.10.10.2

networks:
  vpn_net:
    ipam:
      driver: default
      config:
        - subnet: 10.10.10.0/24

```
