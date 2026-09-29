# 2026-09-29 03:11:58 by RouterOS 7.21.4
# system id = Q7WsO52eAUB
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
/interface wireguard
add listen-port=51820 mtu=1420 name=wg0
/routing ospf instance
add name=default-v2 router-id=1.1.1.1
/routing ospf area
add instance=default-v2 name=backbone
/interface wireguard peers
add allowed-address=10.100.100.1/32,10.100.100.3/32 endpoint-address=\
    51.250.29.98 endpoint-port=51820 interface=wg0 name=peer3 \
    persistent-keepalive=25s public-key=\
    "YbliGIqgfgnHFa1EfnV/vzUTM2iPFysj7KGj1ussKD0="
/ip address
add address=10.100.100.2/24 interface=wg0 network=10.100.100.0
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=backbone networks=10.100.100.0/24 type=nbma
/routing ospf static-neighbor
add address=10.100.100.3%wg0 area=backbone
/system ntp client
set enabled=yes
/system ntp client servers
add address=pool.ntp.org
add address=time.cloudflare.com
