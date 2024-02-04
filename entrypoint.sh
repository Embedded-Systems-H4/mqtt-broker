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
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" admin DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" daniel DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" julian DataIt2024
mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" vlados DataIt2024

# Set the number of dynamic users you want
NUM_DEVICES=3

# Loop to create usernames and set passwords
for i in $(seq 1 $NUM_DEVICES); do
    USERNAME="device-$i"
    PASSWORD="DataIt2024-$i"
    mosquitto_passwd -b "$MOSQUITTO_CONFIG_DIR/passwd" "$USERNAME" "$PASSWORD"
done

# Create a file to define ACL rules
echo "
pattern read main

user admin
topic readwrite #

user device-#
topic readwrite devices/#

user daniel
topic read #

user julian
topic read #

user vlados
topic read #
" > "$MOSQUITTO_CONFIG_DIR/acl.conf"

systemctl restart mosquitto

# Set permissions and ownership for Mosquitto files and directories
chmod 0700 /mosquitto/config/passwd
chmod 0700 /mosquitto/config/acl.conf
chown "$MOSQUITTO_USER:$MOSQUITTO_GROUP" "$MOSQUITTO_CONFIG_DIR/passwd"
chown "$MOSQUITTO_USER:$MOSQUITTO_GROUP" "$MOSQUITTO_CONFIG_DIR/acl.conf"


# Start Mosquitto with the provided configuration file
exec mosquitto -c "$MOSQUITTO_CONFIG_DIR/mosquitto.conf"
