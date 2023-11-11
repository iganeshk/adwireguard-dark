# AdWireGuard

[![Build AdguardHome Dark](https://github.com/iganeshk/adwireguard-dark/actions/workflows/build.yml/badge.svg)](https://github.com/iganeshk/adwireguard-dark/actions/workflows/build.yml)
[![Build AdguardHome Dark](https://github.com/iganeshk/adwireguard-dark/actions/workflows/nightly.yml/badge.svg)](https://github.com/iganeshk/adwireguard-dark/actions/workflows/nightly.yml)
[![Build & Docker Workflow](https://img.shields.io/github/v/release/iganeshk/adwireguard-dark.svg?include_prereleases)](https://github.com/iganeshk/adwireguard-dark/releases)

<p align="center">
  <img src="https://raw.githubusercontent.com/iganeshk/adwireguard-dark/assets/screenshot-adwireguard.png?v1" width="800px" alt="AdWireGuard Screenshot" />
</p>

## What?
Docker container housing both [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome/) and [wg-easy](https://github.com/WeeJeWel/wg-easy) (WireGuard Easy) togther to provide the flexibility of running them at once.

***Note**: On Android, make sure PrivateDNS is disabled to avoid DNS leaking*

## What else?
Bleeding edge distributions for wg-easy patched with security/depenedency updates and adguard home with ~~custom dark theme~~ (temporarily disabled)

### **AdWireGuard**
  - 🐳 **Docker: [ghcr.io](https://github.com/iganeshk/adwireguard-dark/pkgs/container/adwireguard-dark) | [DockerHub](https://hub.docker.com/r/iganesh/adwireguard-dark)**

### **AdGuardHome (Dark)**
  - ~~🐳 Docker: [ghcr.io](https://github.com/iganeshk/adwireguard-dark/pkgs/container/adguardhome-dark) | [DockerHub](https://hub.docker.com/r/iganesh/adguardhome-dark)~~
  - ~~⬇️ [Releases](https://github.com/iganeshk/adwireguard-dark/releases)~~

### **wg-easy**
  - TBA

### Docker-Compose AdWireGuard:
```yaml
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
      # - WEBUI_HOST=0.0.0.0 # Change this to allow binding to other than 0.0.0.0 port
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


### wg-easy Patches 
- Update base image to node18 alpine (holding node20 due to docker build issues for armv6/v7 arch)
- Updated NodeJS to v18.18.2, bump node dependencies & add ability to adjust WebUI host/port
- Add [Dark mode](https://github.com/wg-easy/wg-easy/pull/178)
