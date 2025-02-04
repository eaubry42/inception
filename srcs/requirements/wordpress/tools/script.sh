#!/bin/bash

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"$DB_HOST" --silent; do
    echo "Waiting for MariaDB..."
    sleep 3
done

# create directory to use in nginx container later and also to setup the wordpress conf
mkdir -p /var/www/html
cd /var/www/html

rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

# Create and configure wp-config.php directly
wp config create --dbname="$NEW_DB_NAME" \
                --dbuser="$DB_USER" \
                --dbpass="$DB_PASSWORD" \
                --dbhost="$DB_HOST" \
                --dbprefix="$DB_PREFIX" \
                --allow-root

# Add additional configuration
wp config set WP_HOME "https://${DOMAIN_NAME}" --allow-root
wp config set WP_SITEURL "https://${DOMAIN_NAME}" --allow-root
wp config set WP_DEBUG true --allow-root

# Install WordPress
wp core install --url="https://${DOMAIN_NAME}" \
                --title="$SITE_TITLE" \
                --admin_user="$ADMIN_USER" \
                --admin_password="$ADMIN_PASSWORD" \
                --admin_email="$ADMIN_EMAIL" \
                --skip-email \
                --allow-root

# Create additional user
wp user create "$SCNDUSER_USER" "$SCNDUSER_EMAIL" \
                --role=author \
                --user_pass="$SCNDUSER_PASSWORD" \
                --allow-root

# Install and activate theme
wp theme install twentytwentyfour --activate --allow-root

# Configure PHP-FPM
sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

# Try to repair database if needed
wp db repair --allow-root

# Start PHP-FPM
/usr/sbin/php-fpm7.4 -F