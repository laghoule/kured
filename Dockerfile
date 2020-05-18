FROM golang:1.14.3-alpine as build

WORKDIR /src
COPY . /src

ENV VERSION=master

RUN apk add --no-cache git && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=${VERSION}" -o kured cmd/kured/*.go

FROM alpine:3.11.6
RUN apk --no-cache add ca-certificates tzdata
ADD https://storage.googleapis.com/kubernetes-release/release/v1.15.10/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod 0755 /usr/bin/kubectl
COPY --from=build /src/kured /usr/bin/kured
ENTRYPOINT ["/usr/bin/kured"]