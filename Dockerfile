FROM mono:5.18 AS build

ARG version="v0.3.5.0"

RUN set -x &&\
    apt update && apt install make git -y &&\
    git clone --recursive https://github.com/dyc3/steamguard-cli.git &&\
    cd steamguard-cli &&\
    make


FROM alpine:3.9

RUN set -x &&\
    apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing &&\
    touch /maFiles &&\
    echo "testing" &&\
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies

COPY --from=build /steamguard-cli/build /steamguard-cli
COPY steamguard /steamguard

COPY maFiles /maFiles

CMD /steamguard
