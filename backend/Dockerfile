FROM alpine/curl:3.14
RUN pwd
ls -la
WORKDIR /app
RUN pwd
ls -la
COPY ./api /app/api
ls -la
ENTRYPOINT ["/app/api"]
EXPOSE 8081
