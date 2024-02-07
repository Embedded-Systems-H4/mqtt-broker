FROM eclipse-mosquitto:latest

# Expose MQTT and MQTT over TLS ports
EXPOSE ${MQTT_PORT}

# Copy a script to the container
COPY ./entrypoint.sh /entrypoint.sh

# Make the script executable
RUN chmod +x /entrypoint.sh

# Set the script as the entry point
ENTRYPOINT ["./entrypoint.sh"]
