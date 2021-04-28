FROM docker:stable-git

ENV PYTHONUNBUFFERED=1

# bash and gotemplate
RUN apk --no-cache add bash gomplate

# docker-compose
RUN set -ex; \
    apk add --update --no-cache python3; \
    ln -sf python3 /usr/bin/python; \
    python3 -m ensurepip; \
    pip3 install --no-cache --upgrade pip setuptools; \
    pip install docker-compose

# Sentry CLI
RUN set -ex; \
    apk add --no-cache curl; \
    curl -sL https://sentry.io/get-cli/ | bash; \
    apk del curl
