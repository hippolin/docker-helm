FROM alpine:3.8 as build
LABEL maintainer="Mario Siegenthaler <mario.siegenthaler@linkyard.ch>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.12.0
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=9f96a6e4fc52b5df906da381532cc2eb2f3f57cc203ccaec2b11cf5dc26a7dfc

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.8

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
