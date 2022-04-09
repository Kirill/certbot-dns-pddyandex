#!/bin/bash
_dir="$(dirname "$0")"
source "${HOME}/.certbot-dns-pddyandex.rc"

# Get API key for current domain
API_KEY=${API_KEYMAP["$CERTBOT_DOMAIN"]}
if [ -z "$API_KEY" ]; then
        echo "No API key found for domain $CERTBOT_DOMAIN, exit"
        exit
fi

# Create TXT record
CREATE_DOMAIN="_acme-challenge"
RECORD_ID=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/add" \
     -H "PddToken: $API_KEY" \
     -d "domain=$CERTBOT_DOMAIN&type=TXT&content=$CERTBOT_VALIDATION&ttl=300&subdomain=$CREATE_DOMAIN" \
      | python -c "import sys,json;print(json.load(sys.stdin)['record']['record_id'])")

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
        echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
else
        echo $RECORD_ID >> /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

unset DNS_GOOGLE DNS_CLOUDFLARE DNS_OPENDNS
# Sleep to make sure the change has time to propagate over to DNS (max: 20 min)
c_time=0
end_time=1200
while [ "$c_time" -le "$end_time" ]; do
        if [ `dig $CREATE_DOMAIN.$CERTBOT_DOMAIN TXT +short @dns1.yandex.net | grep $CERTBOT_VALIDATION` ]; then
                sleep 5
                if [ `dig $CREATE_DOMAIN.$CERTBOT_DOMAIN TXT +short @dns2.yandex.net | grep $CERTBOT_VALIDATION` ]; then
                        sleep 5
                        if [ `dig $CREATE_DOMAIN.$CERTBOT_DOMAIN TXT +short @8.8.8.8 | grep $CERTBOT_VALIDATION` ]; then
                                DNS_GOOGLE=1
                        else
                                sleep 50
                                c_time=$[c_time+50]
                        fi
                        if [ `dig $CREATE_DOMAIN.$CERTBOT_DOMAIN TXT +short @1.1.1.1 | grep $CERTBOT_VALIDATION` ]; then
                                DNS_CLOUDFLARE=1
                        else
                                sleep 50
                                c_time=$[c_time+50]
                        fi
                        if [ `dig $CREATE_DOMAIN.$CERTBOT_DOMAIN TXT +short @208.67.222.222 | grep $CERTBOT_VALIDATION` ]; then
                                DNS_OPENDNS=1
                        else
                                sleep 50
                                c_time=$[c_time+50]
                        fi
                        if [ ${DNS_GOOGLE} -eq 1 ] && [ ${DNS_CLOUDFLARE} -eq 1 ] && [ ${DNS_OPENDNS} -eq 1 ]; then
                                break
                        fi
                else
                        sleep 55
                        c_time=$[c_time+55]
                fi
        else
                sleep 60
                c_time=$[c_time+60]
        fi
done
