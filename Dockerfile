# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git curl

RUN cd /
RUN git clone https://github.com/ethereum/go-ethereum -b `curl -s https://api.github.com/repos/ethereum/go-ethereum/releases/latest | grep "tag_name"| cut -d '"' -f 4` --depth=1
RUN cd /go-ethereum && make all

# Pull all binaries into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/* /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
