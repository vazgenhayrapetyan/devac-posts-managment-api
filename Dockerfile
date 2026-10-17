FROM php:8.2-fpm-alpine

# 1. Տեղադրում ենք համակարգային բոլոր անհրաժեշտ գործիքները (ներառյալ git և zip)
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

# 2. Տեղադրում ենք PHP extensions-ը, որոնք պարտադիր են Laravel-ի MySQL-ի և Zip-ի համար
RUN docker-php-ext-install pdo_mysql bcmath zip

# 3. Տեղադրում ենք Composer-ի ամենավերջին տարբերակը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Սահմանում ենք հիմնական աշխատանքային թղթապանակը
WORKDIR /var/www/html

# 5. Թույլատրում ենք Composer-ին աշխատել root իրավունքներով Docker-ի ներսում
ENV COMPOSER_ALLOW_SUPERUSER=1

# 6. Պատճենում ենք ձեր GitHub ռեպոզիտորիայի բոլոր իրական ֆայլերը սերվեր
COPY . .

# 7. Տեղադրում ենք Laravel-ի package-ները՝ շրջանցելով հարթակի պահանջների (extension) խնդիրները
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs --no-interaction

# 8. Տրամադրում ենք ճիշտ թույլտվություններ storage-ին, որպեսզի սպիտակ էջի սխալ չլինի
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Բացում ենք 80 պորտը վեբ տրաֆիկի համար
EXPOSE 80

# 10. Միացնում ենք Supervisor-ը, որն իր հերթին կաշխատեցնի Nginx-ը և PHP-ն
CMD /usr/bin/supervisord -c /etc/supervisord.conf || sleep 3600

