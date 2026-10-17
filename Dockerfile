FROM php:8.3-fpm-alpine

# 1. Տեղադրում ենք համակարգային գործիքները
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    git

# 2. Տեղադրում ենք PHP extensions-ը Laravel-ի համար
RUN docker-php-ext-install pdo_mysql bcmath zip

# 3. ՋՆՋՈՒՄ ԵՆՔ ՀԱՄԱԿԱՐԳԱՅԻՆ ՀԻՆ PHP-ՆԵՐԸ ՈՒ ՍՏԵՂԾՈՒՄ ՃԻՇՏ Symlink
RUN rm -rf /usr/bin/php* /usr/sbin/php* && \
    ln -sf /usr/local/bin/php /usr/bin/php

# 4. Տեղադրում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
ENV COMPOSER_ALLOW_SUPERUSER=1

# 5. ՊԱՏՃԵՆՈՒՄ ԵՆՔ ՊՐՈԵԿՏԻ ՖԱՅԼԵՐԸ (Բացի vendor-ից)
COPY . .

# 6. Տեղադրում ենք package-ները
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs --no-interaction

# 7. Տրամադրում ենք թույլտվություններ storage-ին
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 8. Ստեղծում ենք Nginx կոնֆիգուրացիան
RUN echo 'user www-data;' > /etc/nginx/nginx.conf && \
    echo 'worker_processes auto;' >> /etc/nginx/nginx.conf && \
    echo 'pid /run/nginx.pid;' >> /etc/nginx/nginx.conf && \
    echo 'events { worker_connections 768; }' >> /etc/nginx/nginx.conf && \
    echo 'http {' >> /etc/nginx/nginx.conf && \
    echo '    include /etc/nginx/mime.types;' >> /etc/nginx/nginx.conf && \
    echo '    default_type application/octet-stream;' >> /etc/nginx/nginx.conf && \
    echo '    server {' >> /etc/nginx/nginx.conf && \
    echo '        listen 80;' >> /etc/nginx/nginx.conf && \
    echo '        root /var/www/html/public;' >> /etc/nginx/nginx.conf && \
    echo '        index index.php index.html;' >> /etc/nginx/nginx.conf && \
    echo '        location / {' >> /etc/nginx/nginx.conf && \
    echo '            try_files $uri $uri/ /index.php?$query_string;' >> /etc/nginx/nginx.conf && \
    echo '        }' >> /etc/nginx/nginx.conf && \
    echo '        location ~ \.php$ {' >> /etc/nginx/nginx.conf && \
    echo '            fastcgi_pass 127.0.0.1:9000;' >> /etc/nginx/nginx.conf && \
    echo '            fastcgi_index index.php;' >> /etc/nginx/nginx.conf && \
    echo '            include fastcgi_params;' >> /etc/nginx/nginx.conf && \
    echo '            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/nginx.conf && \
    echo '        }' >> /etc/nginx/nginx.conf && \
    echo '    }' >> /etc/nginx/nginx.conf && \
    echo '}' >> /etc/nginx/nginx.conf

# 9. ՍՏԵՂԾՈՒՄ ԵՆՔ SUPERVISOR ԿՈՆՖԻԳԸ՝ ՈՒՂՂԵԼՈՎ USER=ROOT ԽՆԴԻՐԸ
RUN echo '[supervisord]' > /etc/supervisord.conf && \
    echo 'nodaemon=true' >> /etc/supervisord.conf && \
    echo 'user=root' >> /etc/supervisord.conf && \
    echo '[program:php-fpm]' >> /etc/supervisord.conf && \
    echo 'command=/usr/local/sbin/php-fpm -F' >> /etc/supervisord.conf && \
    echo 'autostart=true' >> /etc/supervisord.conf && \
    echo 'autorestart=true' >> /etc/supervisord.conf && \
    echo '[program:nginx]' >> /etc/supervisord.conf && \
    echo 'command=nginx -g "daemon off;"' >> /etc/supervisord.conf && \
    echo 'autostart=true' >> /etc/supervisord.conf && \
    echo 'autorestart=true' >> /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

