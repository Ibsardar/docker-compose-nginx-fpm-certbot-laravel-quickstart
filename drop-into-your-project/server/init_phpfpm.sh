#!/bin/bash


# navigate
cd "$E_NGINX_ROOT"


# modes:
# demo
if [ "$E_MODE" == "demo" ]; then
    # install
    cp "$E_NGINX_ROOT/server/.env" "./.env"
    composer global require laravel/installer
    laravel new . --jet --stack=inertia --teams --force
    composer require laravel/cashier # uses Stripe for Online Payments
    composer install
    npm install
    # permit
    chown -R root:www-data "$E_NGINX_ROOT"
    find "$E_NGINX_ROOT" -type f -exec chmod 664 {} \;
    find "$E_NGINX_ROOT" -type d -exec chmod 775 {} \;
    # compile
    npm rebuild
    npm run dev
    php artisan key:generate
    php artisan migrate:fresh --seed
fi


# dev
if [ "$E_MODE" == "dev" ]; then
    # install
    cp "$E_NGINX_ROOT/server_dev/.env" "./.env"
    composer install
    npm install
    # permit
    chown -R $USER:www-data "$E_NGINX_ROOT"
    find "$E_NGINX_ROOT" -type f -exec chmod 664 {} \;
    find "$E_NGINX_ROOT" -type d -exec chmod 775 {} \;
    # compile
    npm rebuild
    npm run dev
    php artisan key:generate
    php artisan migrate:fresh --seed
fi


# stage
if [ "$E_MODE" == "stage" ]; then
    # install
    cp "$E_NGINX_ROOT/server_dev/.env" "./.env"
    composer install --optimize-autoloader
    npm install
    # permit
    chown -R root:www-data "$E_NGINX_ROOT"
    find "$E_NGINX_ROOT" -type f -exec chmod 664 {} \;
    find "$E_NGINX_ROOT" -type d -exec chmod 775 {} \;
    # compile
    npm rebuild
    npm run dev
    php artisan key:generate
    php artisan migrate:fresh --seed
fi


# prod
if [ "$E_MODE" == "prod" ]; then
    # install (manually add .env for security purposes)
    composer install --optimize-autoloader --no-dev
    npm install
    # permit
    chown -R root:www-data "$E_NGINX_ROOT"
    find "$E_NGINX_ROOT" -type f -exec chmod 664 {} \;
    find "$E_NGINX_ROOT" -type d -exec chmod 775 {} \;
    # compile (manually migrate and seed for data integrity purposes)
    npm rebuild
    npm run prod
    php artisan key:generate
fi


# common to all modes:
# make sure cache permissions are correct
chgrp -R www-data storage bootstrap/cache
chmod -R ug+rwx storage bootstrap/cache

# clear old cached data
php artisan cache:clear
php artisan config:clear

# notify complete
G='\033[0;32m' # Green
N='\033[0m' # No Color
echo -e $G"Laravel Setup Complete."$N


# final command by modes:
# demo
if [ "$E_MODE" == "demo" ]; then
    # run php-fpm as root in foreground
    echo "Running PHP FPM in foreground..."
    php-fpm -F -R
fi


# dev
if [ "$E_MODE" == "dev" ]; then
    # note: manually run "npm run watch" in parent dev container after application is fully running
    # run php-fpm in foreground
    echo "Running PHP FPM in foreground..."
    php-fpm -F -R
fi


# stage
if [ "$E_MODE" == "stage" ]; then
    # run php-fpm as root in foreground
    echo "Running PHP FPM in foreground..."
    php-fpm -F -R
fi


# prod
if [ "$E_MODE" == "stage" ]; then
    # run php-fpm as root in foreground
    echo "Running PHP FPM in foreground..."
    php-fpm -F -R
fi