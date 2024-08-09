FROM golang:1.20 AS builder
WORKDIR /app
COPY $CI_PROJECT_DIR/momo-store-${VERSION}/api /app/api
ENTRYPOINT ["/app/api"]
EXPOSE 8081
