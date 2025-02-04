FROM debian:bullseye

RUN apt update -y && apt install -y php-fpm php-mysql curl mariadb-client

COPY ./tools/script.sh /
COPY ./tools/wp-config.php /
COPY ./tools/www.conf /etc/php/7.4/fpm/pool.d/

RUN chmod +x /script.sh

CMD ["/script.sh"]