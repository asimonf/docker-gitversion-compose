FROM docker:stable-git

# bash and gotemplate
RUN apk --no-cache add bash gomplate

# docker-compose
RUN set -ex; \
    apk add --no-cache py-pip python-dev libffi-dev openssl-dev gcc libc-dev make; \
    pip install docker-compose

# Sentry CLI
RUN set -ex; \
    apk add --no-cache curl; \
    curl -sL https://sentry.io/get-cli/ | bash; \
    apk del curl
