FROM quay.io/prometheus/golang-builder:latest as build

ENV CGO_ENABLED 0
ADD . /app/beat-exporter
WORKDIR /app/beat-exporter

RUN go get
RUN go build -trimpath -ldflags="-s -w"
RUN chmod +x beat-exporter

FROM ghcr.io/mback2k/node_exporter_hostname:latest

COPY --from=build /app/beat-exporter/beat-exporter /bin/beat-exporter

ENTRYPOINT [ "/bin/node_exporter_hostname", "--launch-program", "/bin/beat-exporter", "--scrape-metrics", "http://127.0.0.1:9479/", "--", "-web.listen-address", "127.0.0.1:9479" ]
