FROM quay.io/prometheus/golang-builder:latest as build

ENV CGO_ENABLED 0
ADD . /app/beat_exporter_hostname
WORKDIR /app/beat_exporter_hostname

RUN go get
RUN go build -trimpath -ldflags="-s -w" -o beat_exporter_hostname
RUN chmod +x beat_exporter_hostname

FROM ghcr.io/mback2k/node_exporter_hostname:latest

COPY --from=build /app/beat_exporter_hostname/beat_exporter_hostname /bin/beat_exporter_hostname

ENTRYPOINT [ "/bin/node_exporter_hostname", "--launch-program", "/bin/beat_exporter_hostname", "--scrape-metrics", "http://127.0.0.1:9479/", "--", "-web.listen-address", "127.0.0.1:9479" ]
