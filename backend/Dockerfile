FROM golang:1.20 AS builder
WORKDIR /app
COPY . /app/
ENTRYPOINT ["/app/cmd/api"]
EXPOSE 8081
