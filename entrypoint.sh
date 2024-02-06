#!/bin/sh

# Set the path to the Mosquitto configuration directory
MOSQUITTO_CONFIG_DIR="/mosquitto/config"
MOSQUITTO_USER="mosquitto"
MOSQUITTO_GROUP="mosquitto"


# Create the Mosquitto configuration file with listener settings
echo "
acl_file $MOSQUITTO_CONFIG_DIR/acl.conf
per_listener_settings false
listener $PORT 0.0.0.0
allow_anonymous false
password_file $MOSQUITTO_CONFIG_DIR/passwd
" > "$MOSQUITTO_CONFIG_DIR/mosquitto.conf"

# Create a file to store user credentials
touch "$MOSQUITTO_CONFIG_DIR/passwd"


# Set permissions and ownership for Mosquitto files and directories
chmod 0700 /mosquitto/config/passwd
chown "$MOSQUITTO_USER:$MOSQUITTO_GROUP" "$MOSQUITTO_CONFIG_DIR/passwd"

mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" admin DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" daniel DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" julian DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" vados DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" device DataIt2024

# Create a file to define ACL rules
echo "
pattern read main

user admin
topic #

user device
topic devices/#

user daniel
topic read #

user julian
topic read #

user vados
topic read #
" > "$MOSQUITTO_CONFIG_DIR/acl.conf"

chmod 0700 /mosquitto/config/acl.conf
chown "$MOSQUITTO_USER:$MOSQUITTO_GROUP" "$MOSQUITTO_CONFIG_DIR/acl.conf"

systemctl restart mosquitto

# Start Mosquitto with the provided configuration file
exec mosquitto -c "$MOSQUITTO_CONFIG_DIR/mosquitto.conf"
