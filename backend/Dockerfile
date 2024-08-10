FROM alpine/curl:3.14
WORKDIR /app
RUN pwd
COPY ./api /app/api
ENTRYPOINT ["/app/api"]
EXPOSE 8081
