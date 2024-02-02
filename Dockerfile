FROM eclipse-mosquitto:latest

# Copy the custom entrypoint script into the container
COPY ./entrypoint.sh /entrypoint.sh

# Set execute permissions on the entrypoint script
RUN chmod +x /entrypoint.sh

# Expose MQTT and MQTT over TLS ports
EXPOSE ${SECURE_PORT}

# Set the entrypoint to the custom script
ENTRYPOINT ["/entrypoint.sh"]
