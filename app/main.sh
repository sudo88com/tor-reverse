#!/bin/bash

if [ "$1" == "generate" ]; then
    if [ -f /web/private_key ]; then
        echo '[-] You already have a private key, delete it if you want to generate a new key'
        exit -1
    fi
    if [ -z "$2" ]; then
        echo '[-] You did not provide any mask. Please provide a mask to generate your ADDRESS'
        exit -1
    else
        echo '[+] Generating the ADDRESS with mask: '$2
        if [ -d /tmp/keys ]; then
            rm /tmp/keys/ -r
        else
            mkdir /tmp/keys
        fi
        mkp224o $2 -n 1 -d /tmp/keys &> /dev/null
        echo '[+] Found '$(cat /tmp/keys/*.onion/hostname)
        cp /tmp/keys/*.onion/*secret_key /web/
        cp /tmp/keys/*.onion/hostname /web/
    fi
fi

if [ "$1" == "serve" ]; then
    chown hidden:hidden -R /web/
    chmod 700 -R /web/

    ADDRESS=$(cat /web/hostname)

    echo '[+] Generating nginx configuration for site '$ADDRESS

    cat << EOF > /web/site.conf
server {
    listen 127.0.0.1:8080;
    root /web/www/;
    index index.php index.html index.htm;
    server_name $ADDRESS;
    location / {
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_pass http://$REVERSE_PROXY;
    }
}
EOF

    if [ ! -f /web/*secret_key ]; then
        echo '[-] Please run this container with the "generate" argument to initialize your web page'
        exit -1
    fi
    echo '[+] Initializing local clock'
    ntpdate -B -q 0.debian.pool.ntp.org
    echo '[+] Starting Tor'
    sudo -u hidden tor -f /etc/tor/torrc &
    echo '[+] Starting nginx'
    nginx &
    
    # Monitor logs
    sleep infinity
fi
