FROM php:rc-apache
LABEL maintainer="richard@pegasio"

RUN apt-get update && apt-get install -y \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libxml2-dev \
  libzip-dev \
  libc-client-dev \
  libkrb5-dev \
  libldap2-dev \
  && apt-get upgrade -y \
  && /bin/rm -r -f /var/lib/apt/lists/* \
  && pecl install APCu-5.1.14 \
  && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
  && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
    pdo_mysql \
    xmlrpc \
    xml \
    json \
    imap \
    zip \
    ldap \
    json \
    intl \
  && docker-php-ext-enable apcu

RUN a2enmod rewrite && service apache2 stop
WORKDIR /var/www/html
COPY start.sh /opt/
RUN chmod +x /opt/start.sh
RUN usermod -u 1000 www-data
CMD /opt/start.sh
EXPOSE 80
