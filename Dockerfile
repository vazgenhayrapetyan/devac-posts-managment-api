FROM php:8.3-fpm-alpine

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

RUN docker-php-ext-install pdo_mysql bcmath zip

RUN rm -rf /usr/bin/php* /usr/sbin/php* && \
    ln -sf /usr/local/bin/php /usr/bin/php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY . .

RUN composer update --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs --no-interaction

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Հիմա այս տողերը 100% կաշխատեն, որովհետև ֆայլերը արդեն կան GitHub-ում
COPY ./docker/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
