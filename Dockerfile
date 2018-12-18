FROM golang:1.10

ENTRYPOINT [ "dep" ]

CMD [ "ensure" ]

WORKDIR /go/src/app

RUN go get -u github.com/golang/dep/cmd/dep

VOLUME [ "/go/src/app" ]

ARG spec="org.opencontainers.image"
ARG BRANCH_NAME
ARG BUILD_DATE
ARG COMMIT_SHA

LABEL ${spec}.created=${BUILD_DATE}
LABEL ${spec}.documentation="https://github.com/darrengruen/docker-golang-dep/README.md"
LABEL ${spec}.source="https://github.com/darrengruen/docker-golang-dep"
LABEL ${spec}.revision="${COMMIT_SHA}"
LABEL ${spec}.version="${BRANCH_NAME}"
LABEL ${spec}.title="Golang dep image"
LABEL ${spec}.description="Run golang dep in docker container"
