ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache jq sshpass rsync openssh

# Hass.io CLI
ARG BUILD_ARCH
RUN apk add --no-cache curl \
    && curl -Lso /usr/bin/ha https://github.com/home-assistant/cli/releases/latest/download/ha_${BUILD_ARCH} \
    && chmod a+x /usr/bin/ha

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

# Run
CMD [ "/run.sh" ]
