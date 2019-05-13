#!/bin/sh

CASUBJ="/CN=OpenVPNCA"
SRVSUBJ="/CN=OpenVPNServer"

PREFIX="openvpn-server"

# Generating Self-Signed CA Certificate

openssl req -new -x509 -newkey rsa:2048 -nodes -keyout "$PREFIX-ca.key" -days 3650 -out "$PREFIX-ca.crt" -subj "$CASUBJ"

# Generating Server Certificate

openssl req -new -newkey rsa:2048 -nodes -keyout "$PREFIX.key" -subj "$SRVSUBJ" -out "$PREFIX.csr"
openssl x509 -req -days 3650 -CA "$PREFIX-ca.crt" -CAkey "$PREFIX-ca.key"  -in "$PREFIX.csr" -out "$PREFIX.crt" -CAcreateserial -CAserial "$PREFIX-serial.txt"

# Generating DH params

openssl dhparam -out "$PREFIX-dh.pem" 1024
