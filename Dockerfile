FROM certbot/certbot:latest

COPY entrypoint.sh /entrypoint.sh
COPY *.sh /root/.certbot-dns-pddyandex/

RUN set -ex && \
    apk add --no-cache curl && \
    chmod +x /root/.certbot-dns-pddyandex/*.sh

ENTRYPOINT [ "/root/.certbot-dns-pddyandex/entrypoint.sh" ]
