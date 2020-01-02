FROM golang:1.12.7


ADD . /app/
WORKDIR /app

RUN go build main.go

ENTRYPOINT [ "go", "run", "main.go" ]
