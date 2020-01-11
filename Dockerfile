FROM golang:stretch as build

ADD . /go/beat-exporter
WORKDIR /go/beat-exporter

RUN go get
RUN go build -ldflags="-s -w"
RUN chmod +x beat-exporter

FROM quay.io/prometheus/busybox:glibc

COPY --from=build /go/beat-exporter/beat-exporter /bin/beat-exporter

ENTRYPOINT [ "/bin/beat-exporter" ]
