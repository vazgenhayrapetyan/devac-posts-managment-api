FROM php:8.2-cli

# Տեղադրում ենք անհրաժեշտ Linux գործիքները
RUN apt-get update -y && apt-get install -y openssl zip unzip git libsqlite3-dev
RUN docker-php-ext-install pdo pdo_sqlite

# Կոդը տեղափոխում ենք Docker-ի ներս
COPY . /app
WORKDIR /app

# Ստեղծում ենք SQLite դատարկ բազա ֆայլի տեսքով, եթե չկա
RUN touch database/database.sqlite

# Գործարկում ենք Laravel-ի ներկառուցված սերվերը ուղիղ 80 պորտով
CMD php artisan migrate --force && php artisan db:seed --force && php artisan serve --host=0.0.0.0 --port=80

EXPOSE 80
