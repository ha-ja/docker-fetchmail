FROM alpine:latest

# Install necessary packages
# tini: process manager for signal forwarding
# su-exec: better su/sudo alternative for containers
# ca-certificates: required for SSL/TLS
RUN apk add --no-cache \
    fetchmail \
    openssl \
    ca-certificates \
    tini \
    su-exec

# set workdir
WORKDIR /data

# setup fetchmail stuff
# fetchmail user is created by installing the fetchmail package
# we create directories with correct permissions upfront
RUN mkdir -p /data/etc /data/log && \
    chown -R fetchmail:fetchmail /data

# add startup script
COPY start.sh /bin/start.sh
RUN chmod +x /bin/start.sh

# copy sample config
COPY fetchmailrc /data/etc/sample/fetchmailrc.sample

VOLUME ["/data"]

# Tini entrypoint ensures signals are handled correctly
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/start.sh"]
