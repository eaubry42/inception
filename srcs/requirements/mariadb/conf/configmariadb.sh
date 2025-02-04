#!/bin/bash
set -e

mysqld --bind-address=0.0.0.0 &
MYSQLD_PID=$!

while ! mysqladmin ping -h"localhost" --silent; do
    sleep 1
done

sleep 1

if mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${NEW_DB_NAME};"; then
    echo "Database ${NEW_DB_NAME} has been successfully created."
else
    echo "Error when creating Database ${NEW_DB_NAME}."
    kill $MYSQLD_PID
    exit 1
fi

if mysql -u root -p${MYSQL_ROOT_PASSWORD} <<-EOSQL
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${NEW_DB_NAME}.* TO '${DB_USER}'@'%';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOSQL
then
    echo "User ${DB_USER} has been successfully created."
else
    echo "Error when creating user ${DB_USER}."
    kill $MYSQLD_PID
    exit 1
fi

kill $MYSQLD_PID

wait $MYSQLD_PID

# Restart MariaDB
exec mysqld --bind-address=0.0.0.0