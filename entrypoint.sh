#!/bin/sh

# Check if MOSQUITTO_USERNAME and MOSQUITTO_PASSWORD are set
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Error: USERNAME or PASSWORD is missing."
  exit 1
fi

# Check if passwd file exists
if [ ! -f /mosquitto/config/passwd ]; then
  # Create the passwd file if it doesn't exist
  touch /mosquitto/config/passwd && \
  touch /mosquitto/config/mosquitto.conf
fi

# Update the password file and set proper permissions
mosquitto_passwd -b /mosquitto/config/passwd $USERNAME $PASSWORD
chmod 0700 /mosquitto/config/passwd
chown mosquitto /mosquitto/config/passwd

echo "listener ${SECURE_PORT}
allow_anonymous false
password_file /mosquitto/config/passwd" > /mosquitto/config/mosquitto.conf

# Start Mosquitto with the provided configuration file
exec mosquitto -c /mosquitto/config/mosquitto.conf
