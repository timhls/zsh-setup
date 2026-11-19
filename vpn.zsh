# ============================================================================
# WireGuard VPN manual control (macOS)
# ============================================================================
# Prevents macOS from auto-connecting the WireGuard NetworkService on wake:
# the service stays disabled otherwise, and disabled services are not
# session-restored. Use these functions instead of the app toggle.
#
# vpn-on:     if already connected, say so and do nothing; otherwise enable
#             the network service, start the tunnel, and wait up to
#             VPN_WAIT_SECS (default 10) for it to reach Connected.
#             Exit 0 on success, 1 on timeout.
#             Starting from the "(Invalid)" (disabled) state auto-launches
#             WireGuard.app (macOS behavior, verified 2026-11-15).
# vpn-off:    stop the tunnel and disable the service (no wake auto-connect),
#             then verify the disabled state was reached.
# vpn-status: show the decoded tunnel state in plain words:
#               connected     — tunnel up (plus tunnel IP and whether the
#                               default route goes through it)
#               disconnected  — service enabled, tunnel down
#               disabled      — service disabled (expected after vpn-off;
#                               scutil shows this as "(Invalid)")
#             Exit 0 when connected, 1 otherwise, 2 if the service is missing.
#
# Overrides (set before sourcing):
#   export VPN_WG_SERVICE="my-wireguard-service"
#   export VPN_WAIT_SECS=20
# ============================================================================
if [[ "$OSTYPE" == darwin* ]]; then
    : "${VPN_WG_SERVICE:=macbook-wireguard}"
    : "${VPN_WAIT_SECS:=10}"

    # Print the raw scutil state token for the service: Connected/Disconnected/
    # Invalid/Unavailable, or "missing" if the service does not exist.
    # Line format: "[*] (State) UUID VPN (proto) \"name\" [...]" — the leading
    # "*" is only present while the service is enabled, so grab the first
    # parenthesized token instead of a fixed field number.
    _vpn_scutil_state() {
        local state
        state=$(scutil --nc list | awk -v svc="$VPN_WG_SERVICE" '
            $0 ~ svc {
                if (match($0, /\([^)]*\)/))
                    print substr($0, RSTART + 1, RLENGTH - 2)
                exit
            }')
        print -r -- "${state:-missing}"
    }

    # True (0) if the tunnel is connected.
    _vpn_is_connected() {
        scutil --nc status "$VPN_WG_SERVICE" | head -1 | grep -q '^Connected'
    }

    # Decode the scutil "(Invalid)" idiom and friends into plain words.
    _vpn_describe_state() {
        local state="$1"
        case "$state" in
            Connected)    print -r -- connected ;;
            Disconnected) print -r -- disconnected ;;
            Invalid)      print -r -- disabled ;;
            *)            print -r -- "$state" ;;
        esac
    }

    vpn-on() {
        if _vpn_is_connected; then
            echo "$VPN_WG_SERVICE: already connected"
            return 0
        fi
        networksetup -setnetworkserviceenabled "$VPN_WG_SERVICE" on \
            && scutil --nc start "$VPN_WG_SERVICE" \
            || { echo "$VPN_WG_SERVICE: failed to start" >&2; return 1 }
        echo -n "$VPN_WG_SERVICE: connecting"
        local waited=0
        while (( waited < VPN_WAIT_SECS )); do
            _vpn_is_connected && { echo ""; echo "$VPN_WG_SERVICE: connected"; return 0 }
            sleep 1
            (( waited += 1 ))
            echo -n "."
        done
        echo ""
        echo "$VPN_WG_SERVICE: not connected after ${VPN_WAIT_SECS}s (state: $(_vpn_describe_state "$(_vpn_scutil_state)"))" >&2
        return 1
    }

    vpn-off() {
        scutil --nc stop "$VPN_WG_SERVICE" 2>/dev/null
        networksetup -setnetworkserviceenabled "$VPN_WG_SERVICE" off \
            || { echo "$VPN_WG_SERVICE: failed to disable" >&2; return 1 }
        local waited=0
        while (( waited < VPN_WAIT_SECS )); do
            [[ "$(_vpn_scutil_state)" == Invalid ]] \
                && { echo "$VPN_WG_SERVICE: disconnected + disabled (no wake auto-connect)"; return 0 }
            sleep 1
            (( waited += 1 ))
        done
        echo "$VPN_WG_SERVICE: stopped, but state is '$(_vpn_describe_state "$(_vpn_scutil_state)")' (expected disabled)" >&2
        return 1
    }

    vpn-status() {
        local state described
        state=$(_vpn_scutil_state)
        if [[ "$state" == missing ]]; then
            echo "$VPN_WG_SERVICE: service not found" >&2
            return 2
        fi
        described=$(_vpn_describe_state "$state")
        echo "$VPN_WG_SERVICE: $described"
        if [[ "$described" == connected ]]; then
            # Tunnel address (WireGuard interface, e.g. 10.10.0.2) and
            # whether the default route goes through the tunnel.
            local tun_ip defroute
            tun_ip=$(ifconfig | awk '/^utun[0-9]+:/{iface=$1; delete seen} \
                /^[[:space:]]*inet /{if (iface != "" && $2 ~ /^10\.10\./) {print $2; exit}}')
            [[ -n "$tun_ip" ]] && echo "  tunnel ip: $tun_ip"
            defroute=$(netstat -rn -f inet | grep '^default' | grep -oE 'utun[0-9]+' | head -1)
            if [[ -n "$defroute" ]]; then
                echo "  default route via $defroute (full tunnel)"
            else
                echo "  default route NOT via tunnel (split tunnel)"
            fi
            return 0
        fi
        [[ "$described" == disabled ]] && \
            echo "  (service disabled — expected after vpn-off; run vpn-on to connect)"
        return 1
    }
fi
