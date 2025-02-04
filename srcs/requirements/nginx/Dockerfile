FROM debian:bullseye

# Update, Install Nginx & OpenSSL
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/nginx.crt \
       -keyout /etc/nginx/ssl/nginx.key \
       -subj "/C=FR/ST=Ile-de-France/L=Paris/O=School/OU=eaubry/CN=eaubry.42.fr/"

# copy the wordpress conf file to the sites available directory
# that contains all the possible site configuration
COPY ./conf/wordpress /etc/nginx/sites-available/wordpress

# Create a symbolic link to make our only config work (Nginx only reads sites-enabled at startup or reload)
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

# The Docker container listen on port 443 at runtime (default port for https)
EXPOSE 443

# run Nginx in the foreground (necessary to keep the container running)
CMD ["nginx", "-g", "daemon off;"]
