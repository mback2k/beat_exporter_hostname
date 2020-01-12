FROM golang:stretch as build

ADD . /go/beat-exporter
WORKDIR /go/beat-exporter

RUN go get
RUN go build -ldflags="-s -w"
RUN chmod +x beat-exporter

FROM mback2k/node_exporter_hostname:latest

COPY --from=build /go/beat-exporter/beat-exporter /bin/beat-exporter

ENTRYPOINT [ "/bin/node_exporter_hostname", "--launch-program", "/bin/beat-exporter", "--scrape-metrics", "http://127.0.0.1:9479/", "--", "-web.listen-address", "127.0.0.1:9479" ]
