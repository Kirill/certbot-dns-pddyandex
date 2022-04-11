#!/usr/bin/env sh

warn () {
    ACCENT='\033[0;33m'
    NC='\033[0m' # No Color
    echo -e "${ACCENT}$1${NC}"
}

notify () {
    ACCENT='\033[0;35m'
    NC='\033[0m' # No Color
    echo -e "${ACCENT}$1${NC}"
}

success () {
    ACCENT='\033[0;32m'
    NC='\033[0m' # No Color
    echo -e "${ACCENT}$1${NC}"
}

( test ! -f "/root/.certbot-dns-pddyandex.rc" || test ! -s "/root/.certbot-dns-pddyandex.rc" ) && warn "Yandex PDD DNS hooks will fail if you don't set up Yandex PDD API Key with [/root/.certbot-dns-pddyandex.rc] file mount"

test -z "$(which curl)" && warn "No [curl] detected, Yandex PDD DNS hooks will fail!" || success "[curl] detected, Yandex PDD DNS hooks could work correctly."
test -z "$(which bash)" && warn "No [bash] detected, Yandex PDD DNS hooks will fail!" || success "[bash] detected, Yandex PDD DNS hooks could work correctly."

test ! -x "/root/.certbot-dns-pddyandex/yandex-hook-auth.sh" && warn "No [auth hook] detected, Yandex PDD DNS hooks will fail!" || success "[Auth hook] detected, Yandex PDD DNS hooks could work correctly."
test ! -x "/root/.certbot-dns-pddyandex/yandex-hook-cleanup.sh" && warn "No [cleanup hook] detected, Yandex PDD DNS hooks will fail!" || success "[Cleanup hook] detected, Yandex PDD DNS hooks could work correctly."


notify "Yandex PDD DNS hooks should be used with parameters: \n\t--manual-auth-hook /root/.certbot-dns-pddyandex/yandex-hook-auth.sh \n\t--manual-cleanup-hook /root/.certbot-dns-pddyandex/yandex-hook-cleanup.sh"

exec certbot $@
