#!/bin/sh
# TODO: temporary code for debugging purose
# Generate self-signed certificates
openssl req -nodes -x509 -newkey rsa:4096 -subj "/C=CI/ST=CI/L=CI/O=CI/CN=CI" \-keyout ProfileServer.key -out ProfileServer.cer -days 365000
openssl pkcs12 -export -out ProfileServer.pfx -inkey ProfileServer.key -in ProfileServer.cer -passout pass:""
 
# Determine the IP address
extip=$(dig +short myip.opendns.com @resolver1.opendns.com)
sed -i -e "/external_server_address =/ s/= .*/= ${extip}/" ./ProfileServer.conf
 
# Run the thing
dotnet ProfileServer.dll