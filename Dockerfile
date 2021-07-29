FROM alpine:3.13

ENV PHP_APK_VERSION=8.0.8-r0

RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/community \
         tar=1.34-r0 \
         supervisor=4.2.1-r0 \
         ca-certificates=20191127-r5 \
         libpng=1.6.37-r1 \
         curl=7.78.0-r0 \
         git=2.30.2-r0 \
         apache2=2.4.48-r0 \
         apache2-ssl=2.4.48-r0 \
         subversion=1.14.1-r0 \
         tzdata=2021a-r0 \
         libmemcached-libs=1.0.18-r4 \
         libevent=2.1.12-r1 \
         yaml=0.2.5-r0 \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community \
        php8=${PHP_APK_VERSION} \
        php8-pecl-apcu=5.1.20-r0 \
        php8-bcmath=${PHP_APK_VERSION} \
        php8-ctype=${PHP_APK_VERSION} \
        php8-curl=${PHP_APK_VERSION} \
        php8-dom=${PHP_APK_VERSION} \
        php8-fileinfo=${PHP_APK_VERSION} \
        php8-iconv=${PHP_APK_VERSION} \
        php8-intl=${PHP_APK_VERSION} \
        php8-openssl=${PHP_APK_VERSION} \
        php8-opcache=${PHP_APK_VERSION} \
        php8-mbstring=${PHP_APK_VERSION} \
        php8-pecl-memcached=3.1.5-r0 \
        php8-mysqlnd=${PHP_APK_VERSION} \
        php8-mysqli=${PHP_APK_VERSION} \
        php8-pcntl=${PHP_APK_VERSION} \
        php8-pgsql=${PHP_APK_VERSION} \
        php8-pdo_mysql=${PHP_APK_VERSION} \
        php8-pdo_pgsql=${PHP_APK_VERSION} \
        php8-phar=${PHP_APK_VERSION} \
        php8-posix=${PHP_APK_VERSION} \
        php8-session=${PHP_APK_VERSION} \
        php8-simplexml=${PHP_APK_VERSION} \
        php8-soap=${PHP_APK_VERSION} \
        php8-sockets=${PHP_APK_VERSION} \
        php8-tokenizer=${PHP_APK_VERSION} \
        php8-xml=${PHP_APK_VERSION} \
        php8-xmlreader=${PHP_APK_VERSION} \
        php8-xmlwriter=${PHP_APK_VERSION} \
        php8-zip=${PHP_APK_VERSION} \
        php8-apache2=${PHP_APK_VERSION} \
        php8-common=${PHP_APK_VERSION} \
        gnu-libiconv=1.15-r3 \
    # xdebug dependencies
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community \
        php8-pecl-xdebug=3.0.4-r0 \
        php8-pear=${PHP_APK_VERSION} \
        php8-dev=${PHP_APK_VERSION} \
        php8-gd=${PHP_APK_VERSION} \
        gcc=10.2.1_pre1-r3 \
        musl-dev=1.2.2-r1 \
        make=4.3-r0 \
        && pecl8 install xdebug \
    && cp /usr/bin/php8 /usr/bin/php

# composer installation
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /run/apache2 && rm -f /run/apache2/apache2.pid \
    && mkdir -p /run/apache2 && rm -f /run/apache2/httpd.pid \
    && mkdir -p /etc/apache2/conf.d/sites-enabled \
    && mkdir -p /var/www/html \
    && chown -R apache:apache /var/www/html

## removing build dependencies
RUN set -xe \
    && apk del gcc \
        make \
        musl-dev \
    && rm -rf /var/cache/apk*

CMD [ "supervisord", "--configuration", "/etc/supervisor/supervisor.conf" ]