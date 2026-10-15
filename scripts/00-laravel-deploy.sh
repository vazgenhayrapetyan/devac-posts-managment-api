#!/usr/bin/env bash

echo "Սկսվում է տվյալների բազայի կարգավորումը օնլայն սերվերում..."

php artisan migrate --force

php artisan db:seed --force

echo "Բոլոր աղյուսակներն ու օգտատերերը հաջողությամբ ստեղծվեցին:"
