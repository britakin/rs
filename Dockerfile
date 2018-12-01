# Stage 1. Build the binary
FROM golang:1.11

ENV RELEASE 0.0.1

# add a non-privileged user
RUN useradd -u 10001 myapp

RUN mkdir -p /go/src/github.com/britakin/rs
ADD . /go/src/github.com/britakin/rs
WORKDIR /go/src/github.com/britakin/rs

# build the binary with go build
RUN CGO_ENABLED=0 go build \
	-ldflags "-s -w -X github.com/britakin/rs/internal/version.Version=${RELEASE}" \
	-o bin/app github.com/britakin/rs/cmd/app

# Stage 2. Run the binary
FROM scratch

ENV PORT 8182
ENV DIAG_PORT 8585

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=0 /etc/passwd /etc/passwd
USER myapp

COPY --from=0 /go/src/github.com/britakin/rs/bin/app /app
EXPOSE $PORT
EXPOSE $DIAG_PORT

CMD ["/app"]