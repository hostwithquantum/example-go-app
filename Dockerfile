FROM golang:1.16 as build
ENV APP_USER app
ENV APP_HOME /app
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
USER $APP_USER
WORKDIR $APP_HOME
ADD go.mod .
ADD go.sum .
ADD main.go .
RUN go mod download
RUN go mod verify
RUN go build -o example-go-app

FROM debian:buster
ENV APP_USER app
ENV APP_HOME /app
ENV HELLO_RESPONSE W-O-R-L-D
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
USER $APP_USER
WORKDIR $APP_HOME
COPY --chown=0:0 --from=build /app/example-go-app $APP_HOME
EXPOSE 8080

CMD ["./example-go-app"]
