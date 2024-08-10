FROM golang:latest AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN cd cmd/api
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o myapp .
RUN ls -la

FROM alpine/curl:3.14
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/cmd/api/myapp /usr/local/bin/myapp
CMD ["myapp"]
EXPOSE 8081
