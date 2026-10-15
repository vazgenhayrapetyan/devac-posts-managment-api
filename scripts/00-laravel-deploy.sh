#!/usr/bin/env bash
echo "Սկսվում է տվյալների բազայի ավտոմատ լրացումը հիշողության մեջ..."

# Աշխատեցնում ենք միգրացիաներն ու սիդերը անմիջապես RAM-ում
php artisan migrate --force
php artisan db:seed --force

echo "Բեքենդը հաջողությամբ միացավ:"
