#!/usr/bin/env bash
echo "Սկսվում է սերվերի գործարկումը..."

# Քեշավորում ենք կոնֆիգուրացիաները արագության համար
php artisan config:cache
php artisan route:cache

echo "PHP-FPM-ը պատրաստ է աշխատանքի:"