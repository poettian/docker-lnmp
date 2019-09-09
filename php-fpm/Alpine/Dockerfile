FROM php:7.2-fpm-alpine

MAINTAINER Poettian <poettian@gmail.com>

RUN set -xe; \
    apk update && \
    pecl channel-update pecl.php.net

# Install the PHP gd extention
RUN apk add --no-cache freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

# Install pcntl
RUN docker-php-ext-install pcntl

# Install bcmath
RUN docker-php-ext-install bcmath

# Install opcache
RUN docker-php-ext-install opcache
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Install mysqli
RUN docker-php-ext-install mysqli

# Install tools
ENV PHPIZE_DEPS \
        autoconf \
        dpkg-dev dpkg \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c
RUN apk add --no-cache --virtual .poettian-phpize-deps $PHPIZE_DEPS

# Install xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

RUN sed -i "s/xdebug.remote_autostart=0/xdebug.remote_autostart=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.remote_enable=0/xdebug.remote_enable=1/" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/xdebug.cli_color=0/xdebug.cli_color=1/" /usr/local/etc/php/conf.d/xdebug.ini

# Install redis
RUN printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Install swoole
RUN apk add --no-cache libstdc++ && \
    pecl install swoole && \
    docker-php-ext-enable swoole

# Install mongodb
RUN pecl install mongodb && \
    docker-php-ext-enable mongodb

# Clear
RUN apk del --no-network .poettian-phpize-deps
