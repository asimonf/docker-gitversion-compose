FROM docker:stable-git

ENV GITVERSION="v4.0.0"
ENV GITVERSION_FILE_NAME="GitVersion_4.0.0"

# bash
RUN apk --no-cache add bash

# docker-compose
RUN set -ex; \
    apk add --no-cache py-pip; \
    pip install docker-compose; \
    apk del py-pip

# mono
RUN set -ex; \
    apk add mono --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# Sentry CLI
RUN set -ex; \
    apk add --no-cache curl; \
    curl -sL https://sentry.io/get-cli/ | bash; \
    apk del curl

# GitVersion
WORKDIR /opt

RUN set -ex; \
    apk add --no-cache curl jq; \
    curl -L $( \
      curl -s https://api.github.com/repos/GitTools/GitVersion/releases/tags/${GITVERSION} | \
      jq -r ".assets[] | select(.name | test(\"${GITVERSION_FILE_NAME}.zip\")) | .browser_download_url" \
    ) -o latest.zip  > /dev/null; \
    mkdir ./GitVersion; \
    unzip latest.zip -d ./GitVersion > /dev/null; \
    rm latest.zip; \
    rm -Rf GitVersion/lib/win32 GitVersion/lib/osx; \
    rm GitVersion/lib/linux/x86_64/libgit2-15e1193.so; \
    apk del curl jq

# Prepare GitVersion for execution on alpine
ADD gitversion /opt/GitVersion
RUN set -ex; \
    apk add --no-cache libssl1.0 libgit2; \
    ln -s /usr/lib/libgit2.so.0.27.3 GitVersion/lib/linux/x86_64/libgit2-15e1193.so; \
    ln -s /opt/GitVersion/gitversion /usr/bin/gitversion
