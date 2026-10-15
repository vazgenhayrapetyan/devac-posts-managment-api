FROM richarvey/nginx-php-fpm:3.1.6

COPY . /var/www/html

ENV WEBROOT /var/www/html/public
ENV APP_ENV production
ENV APP_DEBUG false
ENV RUN_SCRIPTS 1

RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

RUN php artisan migrate --force && php artisan db:seed --force

EXPOSE 80
