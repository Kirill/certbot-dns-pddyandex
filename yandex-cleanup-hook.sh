#!/bin/bash
_dir="$(dirname "$0")"
source "${HOME}/.certbot-dns-pddyandex.rc"

# Get API key for current domain
API_KEY=${API_KEYMAP["$CERTBOT_DOMAIN"]}
if [ -z "$API_KEY" ]; then
       echo "No API key found for domain $CERTBOT_DOMAIN, exit"
       exit
fi

# Remove the challenge TXT record from the zone
remove_record() {
        RECORD_ID="$1"
if [ -n "${RECORD_ID}" ]; then
        RESULT=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/del" \
        -H "PddToken: $API_KEY" \
        -d "domain=$CERTBOT_DOMAIN&record_id=$RECORD_ID" \
         | python -c "import sys,json;print(json.load(sys.stdin)['success'])")
        echo $RESULT
fi
}

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        while read RECORD; do
                remove_record $RECORD
        done < /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi
