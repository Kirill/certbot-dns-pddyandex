# certbot-dns-pddyandex

PDD Yandex DNS API for certbot --manual-auth-hook --manual-cleanup-hook
Install and renew Let's encrypt wildcard ssl certificate for domain *.site.com using PDD Yandex DNS API:

## 1. Install CertBot

Follow instructions on <https://certbot.eff.org/all-instructions>

## 2. Clone this repo

```bash
git clone https://github.com/dmitriysafronov/certbot-dns-pddyandex/ ~/.certbot-dns-pddyandex
```

## 3. Set API KEY

Get your PDD Yandex API key from <https://pddimp.yandex.ru/api2/admin/get_token> and add it to `~/.certbot-dns-pddyandex.rc`

```bash
nano ~/.certbot-dns-pddyandex.rc
```

## 4. You're ready for the action

You could rework and add this scripts to cron any preferred way.

### 4.1. Generate wildcard

remove `--dry-run` for real action

```bash
certbot certonly \
    --manual-public-ip-logging-ok \
    --agree-tos \
    --renew-by-default \
    -d site.com -d *.site.com \
    --manual \
    --manual-auth-hook ~/.certbot-dns-pddyandex/yandex-auth-hook.sh \
    --manual-cleanup-hook ~/.certbot-dns-pddyandex/yandex-cleanup-hook.sh \
    --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory \
    --register-unsafely-without-email --dry-run
```

### 4.2 Force Renew

```bash
certbot renew \
    --force-renew \
    --manual \
    --manual-auth-hook ~/.certbot-dns-pddyandex/yandex-auth-hook.sh \
    --manual-cleanup-hook ~/.certbot-dns-pddyandex/yandex-cleanup-hook.sh \
    --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```
