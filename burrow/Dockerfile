FROM golang:1.13-alpine as builder

ENV DEP_VERSION="0.5.1"
RUN apk add --no-cache bash curl gcc git libc-dev && \
	curl -L -s https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-linux-amd64 -o $GOPATH/bin/dep && \
	chmod +x $GOPATH/bin/dep && \
	GO111MODULE=on go get github.com/linkedin/Burrow


# COPY uptime.sh .
# RUN chmod +x uptime.sh

# RUN mkdir -p /var/log/ && touch /var/log/faillog
# ENTRYPOINT [ "./uptime.sh" ]


RUN cp -R $GOPATH/bin/Burrow /tmp/Burrow


## stage 2: runner
FROM alpine:3.10

COPY --from=builder /tmp/Burrow /app/

WORKDIR /app/

ADD burrow-config/burrow.toml /etc/burrow/
COPY start.sh /app/

RUN mkdir -p /etc/run /etc/log && chmod +x /app/start.sh

CMD ["./start.sh"]
