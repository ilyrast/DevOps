FROM golang:1.20 AS builder
WORKDIR /app
COPY ./cmd /app/cmd
ENTRYPOINT ["/app/cmd/api"]
EXPOSE 8081
