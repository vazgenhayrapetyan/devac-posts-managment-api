FROM richarvey/nginx-php-fpm:3.1.6

COPY . /var/www/html

# Image-ի հիմնական կարգավորումները
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Լոգերը ուղղում ենք Docker տերմինալ
ENV LOG_CHANNEL stderr

# Laravel-ի հիմնական ռեժիմը
ENV APP_ENV production
ENV APP_DEBUG true

# ՈՒՂՂՎԱԾ Է. Ավելացրել ենք --no-scripts դրոշակը՝ build-ի ժամանակ սխալները կանխելու համար
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# Թույլտվություններ թղթապանակների համար
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["/start.sh"]
