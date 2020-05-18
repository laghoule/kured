FROM golang:1.14.3-alpine as build

WORKDIR /src
COPY . /src

RUN apk add --no-cache git make && \
    make

FROM alpine:3.11.6
RUN apk --no-cache add ca-certificates tzdata
ADD https://storage.googleapis.com/kubernetes-release/release/v1.15.10/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod 0755 /usr/bin/kubectl
COPY --from=build /src/kured /usr/bin/kured
ENTRYPOINT ["/usr/bin/kured"]