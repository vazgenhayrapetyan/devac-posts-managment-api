FROM php:8.2-fpm-alpine

# Տեղադրում ենք Nginx և Supervisor
RUN apk update && apk add --no-cache nginx supervisor

# Ստեղծում ենք պարզ Test էջ, որը ցույց կտա, որ սերվերը Live է
RUN mkdir -p /var/www/html/public && \
    echo "<?php echo '<h1>Render Server is 100% Working! Local time: ' . date('Y-m-d H:i:s') . '</h1>'; ?>" > /var/www/html/public/index.php

# Պատճենում ենք սերվերի կոնֆիգուրացիաները
COPY ./docker/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
