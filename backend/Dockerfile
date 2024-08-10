FROM alpine/curl:3.14
RUN pwd
RUN ls -la
WORKDIR /app
RUN pwd
RUN ls -la
COPY ./api /app/api
RUN ls -la
ENTRYPOINT ["/app/api"]
EXPOSE 8081
