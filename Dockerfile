FROM certbot/certbot:latest

COPY *.sh /root/.certbot-dns-pddyandex/

RUN set -ex && \
    apk add --no-cache curl && \
    chmod +x /root/.certbot-dns-pddyandex/*.sh

ENTRYPOINT [ "/root/.certbot-dns-pddyandex/entrypoint.sh" ]
