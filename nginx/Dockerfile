FROM nginx:1.16.1

WORKDIR /srv/www

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf