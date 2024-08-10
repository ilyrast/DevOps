FROM golang:1.20 AS builder
WORKDIR /app
COPY . /app/
ENTRYPOINT ["/app/cmd/api"]
EXPOSE 8081

FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go run ./cmd/api 


FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/api /usr/local/bin/myapp
EXPOSE 8081
CMD ["myapp"]
