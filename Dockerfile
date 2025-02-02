FROM golang:1.9.2
WORKDIR /go/src/github.com/kelseyhightower/app/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build .

FROM scratch
# hadolint ignore=DL3022,DL3045
COPY --from=0 /go/src/github.com/kelseyhightower/app/app .
ENTRYPOINT ["/app"]
