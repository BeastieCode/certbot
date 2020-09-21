FROM nginx:1.16.1-alpine
LABEL maintainer="michal@beastiecode.com"

RUN apk add certbot
RUN mkdir -p /var/www/html
EXPOSE 80 443

VOLUME /etc/letsencrypt /var/lib/letsencrypt

COPY nginx.conf /etc/nginx/conf.d/site.conf
COPY entrypoint.sh /script/entrypoint.sh

ENTRYPOINT [ ]
CMD ["bin/sh","/script/entrypoint.sh"];
