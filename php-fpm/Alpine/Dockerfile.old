FROM php:7.2-fpm-alpine

MAINTAINER Poettian <poettian@gmail.com>

ENV HOMEDIR /root/

ENV PHPEX_DEPS $PHPIZE_DEPS \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        zlib-dev \
        libxpm-dev \
        imap-dev \
        openldap-dev \
        tidyhtml-dev \
        libxslt-dev \
        krb5-dev \
        gettext-dev \
        icu-dev \
        postgresql-dev \
        libzip-dev \
        libmemcached-dev

WORKDIR $HOMEDIR

# 安装基础包
RUN apk update && apk add --no-cache --virtual .phpex-deps $PHPEX_DEPS

# 编译安装源码包自带的扩展
RUN set -eux; \
    docker-php-ext-configure gd \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include/ \
        --with-xpm-dir=/usr/include \
        --with-webp-dir=/usr/include \
        --with-freetype-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
        bcmath \
        exif \
        gettext \
        intl \
        ldap \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        pcntl \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        tidy \
        wddx \
        xsl \
        opcache \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install -j$(nproc) zip

# 通过pecl安装的扩展
RUN set -eux; \
    pecl install igbinary-3.0.1 \
    && pecl install memcached-3.1.3 \
    && pecl install mongodb-1.5.5 \
    && pecl install msgpack-2.0.3 \
    && pecl install xdebug-2.7.2 \
    && pecl install redis-5.0.2 \
    && docker-php-ext-enable igbinary redis memcached mongodb xdebug msgpack

