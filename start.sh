#!/bin/sh
set -e

# Copy sample config if none exists
if [ ! -f /data/etc/fetchmailrc ]; then
    echo "No fetchmailrc found, copying sample..."
    cp /data/etc/sample/fetchmailrc.sample /data/etc/fetchmailrc
fi

# Fix permissions (fetchmail is strict about this)
chmod 0700 /data/etc/fetchmailrc
chown -R fetchmail:fetchmail /data/etc

# Set poll interval (default 300s)
FETCHMAIL_POLL=${TIMECRON:-300}

echo "Starting fetchmail with poll interval ${FETCHMAIL_POLL}s..."

# Run fetchmail
# --nodetach: keep process in foreground
# --daemon: poll every X seconds
# --nosyslog: don't use syslog
# --logfile /dev/stdout: write logs to stdout for Docker
exec su-exec fetchmail fetchmail \
    -f /data/etc/fetchmailrc \
    --nodetach \
    --daemon "$FETCHMAIL_POLL" \
    --nosyslog \
    --logfile /dev/stdout
