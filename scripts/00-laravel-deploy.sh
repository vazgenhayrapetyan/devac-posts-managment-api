#!/usr/bin/env bash
echo "Սկսվում է տվյալների բազայի ավտոմատ միգրացիան..."

# Ստեղծում ենք SQLite բազան ճիշտ տեղում
touch database/database.sqlite
chmod 777 database/database.sqlite

# Գործարկում ենք հրամանները
php artisan migrate --force
php artisan db:seed --force

echo "Բեքենդը պատրաստ է:"
