# ============================================================================
# WireGuard VPN manual control (macOS)
# ============================================================================
# Prevents macOS from auto-connecting the WireGuard NetworkService on wake:
# the service stays disabled otherwise, and disabled services are not
# session-restored. Use these functions instead of the app toggle.
#
# vpn-on:    enable the network service and start the tunnel
# vpn-off:   stop the tunnel and disable the service (no wake auto-connect)
# vpn-status: show the tunnel state via scutil
#
# Override VPN_WG_SERVICE before sourcing if your service is named differently:
#   export VPN_WG_SERVICE="my-wireguard-service"
# ============================================================================
if [[ "$OSTYPE" == darwin* ]]; then
    : "${VPN_WG_SERVICE:=macbook-wireguard}"

    vpn-on() {
        networksetup -setnetworkserviceenabled "$VPN_WG_SERVICE" on \
            && scutil --nc start "$VPN_WG_SERVICE" \
            && echo "$VPN_WG_SERVICE: connecting"
    }

    vpn-off() {
        scutil --nc stop "$VPN_WG_SERVICE" 2>/dev/null
        networksetup -setnetworkserviceenabled "$VPN_WG_SERVICE" off \
            && echo "$VPN_WG_SERVICE: disconnected + disabled (no wake auto-connect)"
    }

    vpn-status() {
        scutil --nc list | grep -i wireguard
    }
fi
