FROM richarvey/nginx-php-fpm:3.1.6

COPY . /var/www/html

# Պորտային միացում սոկետի փոխարեն (Վերացնում է Socket 500 սխալը)
ENV PHP_FPM_LISTEN 127.0.0.1:9000
ENV WEBROOT /var/www/html/public
ENV APP_ENV production
ENV APP_DEBUG false
ENV RUN_SCRIPTS 1

# Թույլտվություններ
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
