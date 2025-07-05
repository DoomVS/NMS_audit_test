FROM alpine:3.20

RUN apk add --no-cache bash curl git tar ca-certificates

# Semgrep
RUN curl -L https://github.com/returntocorp/semgrep/releases/latest/download/semgrep-linux-amd64 \
    -o /usr/local/bin/semgrep && chmod +x /usr/local/bin/semgrep

# Trivy
RUN curl -sSL https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.64.1_Linux-64bit.tar.gz \
    | tar -xz -C /usr/local/bin --strip-components=1 trivy && chmod +x /usr/local/bin/trivy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
