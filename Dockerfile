FROM alpine:3.7

ENV PHP_APK_VERSION=7.1.33-r0

RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/community \
        tar \
        supervisor \
        ca-certificates=20190108-r0 \
        libpng=1.6.37-r0 \
        curl=7.61.1-r3 \
        git=2.15.4-r0 \
        apache2=2.4.41-r0 \
        apache2-ssl=2.4.41-r0 \
        subversion=1.9.12-r0 \
        tzdata=2019c-r0 \
        openssh-client=7.5_p1-r10 \
        libmemcached-libs=1.0.18-r2 \
        libevent=2.1.8-r2 \
        libssl1.0=1.0.2t-r0 \
        musl=1.1.18-r4 \
        yaml=0.1.7-r0 \
        php7=${PHP_APK_VERSION} \
        php7-apcu=5.1.11-r0 \
        php7-bcmath=${PHP_APK_VERSION} \
        php7-ctype=${PHP_APK_VERSION} \
        php7-curl=${PHP_APK_VERSION} \
        php7-dom=${PHP_APK_VERSION} \
        php7-fileinfo=${PHP_APK_VERSION} \
        php7-iconv=${PHP_APK_VERSION} \
        php7-intl=${PHP_APK_VERSION} \
        php7-json=${PHP_APK_VERSION} \
        php7-openssl=${PHP_APK_VERSION} \
        php7-opcache=${PHP_APK_VERSION} \
        php7-mbstring=${PHP_APK_VERSION} \
        php7-memcached=3.0.4-r0 \
        php7-mysqlnd=${PHP_APK_VERSION} \
        php7-mysqli=${PHP_APK_VERSION} \
        php7-pcntl=${PHP_APK_VERSION} \
        php7-pgsql=${PHP_APK_VERSION} \
        php7-pdo_mysql=${PHP_APK_VERSION} \
        php7-pdo_pgsql=${PHP_APK_VERSION} \
        php7-pdo_sqlite=${PHP_APK_VERSION} \
        php7-phar=${PHP_APK_VERSION} \
        php7-posix=${PHP_APK_VERSION} \
        php7-session=${PHP_APK_VERSION} \
        php7-simplexml=${PHP_APK_VERSION} \
        php7-soap=${PHP_APK_VERSION} \
        php7-sockets=${PHP_APK_VERSION} \
        php7-tokenizer=${PHP_APK_VERSION} \
        php7-xml=${PHP_APK_VERSION} \
        php7-xmlreader=${PHP_APK_VERSION} \
        php7-xmlwriter=${PHP_APK_VERSION} \
        php7-zip=${PHP_APK_VERSION} \
        php7-apache2=${PHP_APK_VERSION} \
        # xdebug dependencies
        php7-pear=${PHP_APK_VERSION} \
        php7-dev=${PHP_APK_VERSION} \
        php7-gd=${PHP_APK_VERSION} \
        gcc=6.4.0-r5 \
        musl-dev=1.1.18-r4 \
        make=4.2.1-r0 \
    # alpine 3.10 is the first version that provides a gnu-libiconv with the preload library needed
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.10/community/ --allow-untrusted \
        gnu-libiconv=1.15-r2 \
        php7-common=${PHP_APK_VERSION} \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
        gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# xdebug installation
RUN pecl install xdebug-2.9.6

# composer installation
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN cp /usr/bin/php7 /usr/bin/php && rm -f /var/cache/apk/* \
    && mkdir -p /run/apache2 && rm -f /run/apache2/apache2.pid \
    && mkdir -p /run/apache2 && rm -f /run/apache2/httpd.pid \
    && mkdir -p /etc/apache2/conf.d/sites-enabled

# php rebuild gd depenencies
RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/community \
        libwebp-dev=0.6.0-r1 \
        libwebp=0.6.0-r1 \
        autoconf=2.69-r0 \
        automake=1.15.1-r0 \
        libjpeg=8-r6 \
        libjpeg-turbo=1.5.3-r3 \
        libjpeg-turbo-dev=1.5.3-r3 \
        libpng=1.6.37-r0 \
        libpng-dev=1.6.37-r0 \
        libxpm=3.5.12-r0 \
        libxpm-dev=3.5.12-r0 \
        freetype=2.8.1-r4 \
        freetype-dev=2.8.1-r4

# rebuild gd with image suport
RUN mkdir -p /usr/build/php \
    && cd /usr/build/php \
    && wget https://www.php.net/distributions/php-7.1.33.tar.bz2 \
    && tar -xvf php-7.1.33.tar.bz2 \
    && cd /usr/build/php/php-7.1.33/ext/gd \
    && phpize \
    &&  ./configure --prefix=/usr \
            --enable-shared \
            --with-webp-dir=/usr/lib \
            --with-jpeg-dir=/usr/lib \
            --with-png-dir=/usr/lib \
            --with-freetype-dir=/usr/lib \
            --with-xpm-dir=/usr/lib \
    && make \
    && cp -r /usr/build/php/php-7.1.33/ext/gd/modules/ /usr/lib/php7/modules/ \
    && rm rf -rf /usr/build/php

# removing build dependencies
RUN set -xe \
    && apk del --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/community \
        gcc \
        libwebp-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libxpm-dev \
        freetype-dev \
        automake \
        autoconf \
        make \
        musl-dev

RUN mkdir -p /var/www/html \
    && chown -R apache:apache /var/www/html \
    && rm -rf /var/cache/apk*

CMD [ "supervisord", "--configuration", "/etc/supervisor/supervisor.conf" ]