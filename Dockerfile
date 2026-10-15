FROM richarvey/nginx-php-fpm:3.1.6

COPY . /var/www/html

# Image-ի հիմնական կարգավորումները (Միացնում ենք Composer-ը)
ENV NOW_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Լոգերը ուղղում ենք Docker տերմինալ
ENV LOG_CHANNEL stderr

# Laravel-ի հիմնական ռեժիմը
ENV APP_ENV production
ENV APP_DEBUG true

# Տեղադրում ենք Laravel-ի բոլոր պակասող փաթեթները (vendor թղթապանակը)
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Թույլտվություններ թղթապանակների համար
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["/start.sh"]
