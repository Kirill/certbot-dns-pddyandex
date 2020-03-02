# certbot-dns-pddyandex
PDD Yandex DNS API for certbot --manual-auth-hook --manual-cleanup-hook
Install and renew Let's encrypt wildcard ssl certificate for domain *.site.com using PDD Yandex DNS API:

#### 1) Clone this repo and set the API key
```bash
git clone https://github.com/zompaktu/certbot-dns-pddyandex/ && cd ./certbot-dns-pddyandex
```

#### 2) Set API KEY

Get your PDD Yandex API key from https://pddimp.yandex.ru/api2/admin/get_token
and add it to ./config.sh

#### 3) Install CertBot

Follow instructions on https://certbot.eff.org/all-instructions

#### 4) Generate wildcard
```bash
certbot certonly --manual-public-ip-logging-ok --agree-tos --renew-by-default -d site.com -d *.site.com --manual --manual-auth-hook ../certbot-dns-pddyandex/yandex-auth-hook.sh --manual-cleanup-hook ../certbot-dns-pddyandex/yandex-cleanup-hook.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --register-unsafely-without-email
```

#### 5) Force Renew
```bash
certbot renew --force-renew --manual --manual-auth-hook ../certbot-dns-pddyandex/yandex-auth-hook.sh --manual-cleanup-hook ../certbot-dns-pddyandex/yandex-cleanup-hook.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```