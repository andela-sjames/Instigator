ARG GOLANG_VERSION=1.9.7-alpine3.7

FROM golang:$GOLANG_VERSION

ENV BURROW_VERSION="0.3.2"
RUN apk add --no-cache git curl && \
	curl -L -s https://github.com/golang/dep/releases/download/v${BURROW_VERSION}/dep-linux-amd64 -o $GOPATH/bin/dep && \
	chmod +x $GOPATH/bin/dep && \
	go get github.com/linkedin/Burrow

RUN cd $GOPATH/src/github.com/linkedin/Burrow && dep init && dep ensure && go install

# create and set working directory
WORKDIR /etc/burrow/

ADD burrow-config/burrow.toml /etc/burrow/
COPY start.sh /etc/burrow/

RUN mkdir -p /etc/run /etc/log
RUN chmod +x /etc/burrow/start.sh

CMD ["./start.sh"]