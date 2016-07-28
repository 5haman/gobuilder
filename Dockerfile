FROM gliderlabs/alpine

ENV GOPATH=/go \
    GO15VENDOREXPERIMENT=1 \
    CGO_ENABLED=0 \
    GOOS=linux \
    SWARM_VERSION=1.2.3 \
    REGISTRATOR_VERSION=7

WORKDIR /go/src/github.com/gliderlabs
RUN set -ex \
    && apk-install bash build-base curl go git mercurial \
    && git clone https://github.com/gliderlabs/registrator \
    #&& mkdir /go/src/github.com/docker \
    #&& cd /go/src/github.com/docker \
    #&& curl -sSL https://github.com/docker/swarm/archive/v${SWARM_VERSION}.tar.gz | tar xz \
    #&& mv swarm-${SWARM_VERSION} swarm \
    && cd /go/src/github.com/gliderlabs/registrator \
    && go get \
    && go build -ldflags "-s -X main.Version $(cat VERSION)" \
    #&& cd /go/src/github.com/docker/swarm \
    #&& go install -v -a -tags netgo -installsuffix netgo \
    #    -ldflags "-s -w -X github.com/docker/swarm/version.GITCOMMIT=-X `git rev-parse --short HEAD` \
    #    -X github.com/docker/swarm/version.BUILDTIME \"`date -u`\""  \
    #&& strip /go/bin/swarm \
    && strip /go/bin/registrator \
    && mv /go/bin/* /usr/local/bin \
    && rm -rf /go \
    && apk del --purge build-base go git mercurial

WORKDIR /usr/local/bin

ENTRYPOINT ["/bin/bash"]
