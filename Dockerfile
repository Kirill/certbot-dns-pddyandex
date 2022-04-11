FROM certbot/certbot:latest

COPY *.sh /root/.certbot-dns-pddyandex/

RUN set -ex && \
    chmod a+x /root/.certbot-dns-pddyandex/*.sh && \
    apk add --no-cache curl bash

ENTRYPOINT [ "/root/.certbot-dns-pddyandex/entrypoint.sh" ]
