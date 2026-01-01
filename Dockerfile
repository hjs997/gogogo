FROM golang:1.22-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git ca-certificates tzdata \
    && update-ca-certificates

ENV GOPROXY=https://proxy.golang.org,direct
ENV GO111MODULE=on

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o app

FROM alpine:latest

RUN apk add --no-cache ca-certificates curl bash tzdata \
    && update-ca-certificates

WORKDIR /root/

COPY --from=builder /app/app .

EXPOSE 7860
CMD ["./app"]
