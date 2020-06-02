FROM nginx:1.16.1

RUN rm -f /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/conf.d/fullout_analytics.conf
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf