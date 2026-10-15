#!/usr/bin/env bash
echo "Սկսվում է տվյալների բազայի ավտոմատ միգրացիան..."

# Ստեղծում ենք SQLite բազայի ֆայլը, եթե այն գոյություն չունի
if [ ! -f /var/www/html/database/database.sqlite ]; then
    echo "Ստեղծվում է database.sqlite ֆայլը..."
    touch /var/www/html/database/database.sqlite
fi

# Տալիս ենք ֆայլին կարդալու և գրելու լիարժեք իրավունքներ
chmod 777 /var/www/html/database/database.sqlite

# Գործարկում ենք միգրացիաները
php artisan migrate --force

# Լրացնում ենք մեր 3 օգտատերերին (Admin, Editor, Search)
php artisan db:seed --force

echo "Բոլոր աղյուսակներն ու օգտատերերը հաջողությամբ ստեղծվեցին օնլայն բազայում:"
