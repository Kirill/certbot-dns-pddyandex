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

( test -z "${API_KEYMAP}" && ( test ! -f "/root/.certbot-dns-pddyandex.rc" || test ! -s "/root/.certbot-dns-pddyandex.rc" ) ) && warn "Yandex PDD DNS hooks will fail if you don't set up Yandex PDD API Key with one of methods: \n\t- [/root/.certbot-dns-pddyandex.rc] file mount (preferrable) \n\t- [API_KEYMAP] env var (insecure, not recomended)"
( test -n "${API_KEYMAP}" && test -r "/root/.certbot-dns-pddyandex.rc" && test -s "/root/.certbot-dns-pddyandex.rc" ) && warn "Please set Yandex PDD API Key with only one method!"
( test -z "${API_KEYMAP}" && ( test ! -f "/root/.certbot-dns-pddyandex.rc" || test ! -s "/root/.certbot-dns-pddyandex.rc" ) ) || ( echo "Setting [API_KEYMAP] environment variable is insecure, use passwordfile [/root/.certbot-dns-pddyandex.rc] instead"; echo "${API_KEYMAP}" > "/root/.certbot-dns-pddyandex.rc" )

test -z "$(which curl)" && warn "No cURL detected, Yandex PDD DNS hooks will fail!" || success "cURL detected, Yandex PDD DNS hooks could work correctly."
test ! -x "/root/.certbot-dns-pddyandex/yandex-hook-auth.sh" && warn "No auth hook detected, Yandex PDD DNS hooks will fail!" || success "Auth hook detected, Yandex PDD DNS hooks could work correctly."
test ! -x "/root/.certbot-dns-pddyandex/yandex-hook-cleanup.sh" && warn "No cleanup hook detected, Yandex PDD DNS hooks will fail!" || success "Cleanup hook detected, Yandex PDD DNS hooks could work correctly."


notify "Yandex PDD DNS hooks should be used with parameters: \n\t--manual-auth-hook /root/.certbot-dns-pddyandex/yandex-hook-auth.sh \n\t--manual-cleanup-hook /root/.certbot-dns-pddyandex/yandex-hook-cleanup.sh"

exec certbot $@
