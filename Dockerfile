FROM certbot/certbot:latest

COPY entrypoint.sh /entrypoint.sh
COPY yandex-auth-hook.sh yandex-cleanup-hook.sh /root/.certbot-dns-pddyandex/

RUN set -ex && \
    apk add --no-cache curl && \
    chmod +x /entrypoint.sh && \
    chmod +x /root/.certbot-dns-pddyandex/*.sh

ENTRYPOINT [ "/entrypoint.sh" ]
