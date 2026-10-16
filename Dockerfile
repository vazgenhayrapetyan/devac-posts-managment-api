FROM php:8.2-fpm-alpine

# Տեղադրում ենք համակարգային կախվածությունները և MySQL extensions-ը
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql bcmath

# Տեղադրում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Պատճենում ենք պրոեկտի ֆայլերը
COPY . .

# Տեղադրում ենք բոլոր PHP package-ները
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Կարգավորում ենք թղթապանակների թույլտվությունները ներկառուցված www-data օգտատիրոջ համար
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Պատճենում ենք սերվերի կոնֆիգուրացիաները
COPY ./docker/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
