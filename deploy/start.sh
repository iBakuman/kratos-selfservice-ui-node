if [ -z ${NAMESERVER+x} ]; then
    if [ -f /etc/resolv.conf ]; then
        export NAMESERVER=$(awk '/^nameserver/{print $2}' /etc/resolv.conf)
    else
        # see https://www.emmanuelgautier.com/blog/nginx-docker-dns-resolution
        export NAMESERVER="127.0.0.11"
    fi
fi

echo "Nameserver is: $NAMESERVER"

if [ -z ${KRATOS_PUBLIC_URL+x} ]; then
    echo "KRATOS_PUBLIC_URL is unset.  Please set the environment variable 'KRATOS_PUBLIC_URL'";
    exit 3
fi

/docker-entrypoint.sh nginx -g "daemon off;"