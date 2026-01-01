FROM golang:1.22-alpine AS builder

WORKDIR /app

RUN apk add --no-cache \
    git \
    ca-certificates \
    tzdata \
    && update-ca-certificates

ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,https://proxy.golang.org,direct

COPY go.mod go.sum ./

RUN go env && go mod download -x

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o app
