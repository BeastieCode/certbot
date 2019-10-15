nginx -g "daemon off;" &
if [ -z "$CERTBOT_RENEW" ] ; then
    certbot certonly --webroot --webroot-path=/var/www/html --email $CERTBOT_EMAIL --agree-tos --no-eff-email --staging -d $CERTBOT_DOMAIN
else
    certbot renew --dry-run
fi
