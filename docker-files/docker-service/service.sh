#!/usr/bin/env bash

echo "$(sed 's/^nameserver.*/nameserver 8.8.8.8/g' /etc/resolv.conf)" > /etc/resolv.conf

while true; do
    DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3 }')
    PUBLIC_IP=$(wget -q -O - ipinfo.io/ip)

cat << EOF > /tmp/html/index.html
    <!doctype html>
    <html>
        <head>
            <title>Host Info</title>
        </head>
        <body>
            <p>Host name is: ${HOSTNAME}</p><br>
            <p>Host IP is: ${DOCKER_HOST}</p><br>
            <p>Public IP is: ${PUBLIC_IP}</p>
        </body>
    </html>
EOF
    sleep 3;
done
