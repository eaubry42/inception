FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./conf/configmariadb.sh /usr/local/bin/configmariadb.sh

RUN chmod +x /usr/local/bin/configmariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/configmariadb.sh"]