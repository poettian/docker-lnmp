FROM centos:centos6.10

MAINTAINER Poettian <poettian@gmail.com>

USER root

RUN yum install -y epel-release

#####################################
# basic php-cli php-fpm and extensions
#####################################

RUN yum install -y php-cli \
    php-fpm \
    php-bcmath \
    php-xml \
    php-gd \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-tidy \
    php-process && \
    yum clean all && \
    rm -rf /var/cache/yum

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
    
#####################################
# compile tools
#####################################

RUN yum install -y wget \
    gcc \
    gcc+ \
    gcc-c++ \
    make \
    libmcrypt \
    openssl-devel \
    pcre-devel \
    php-pear \
    php-devel

#####################################
# php redis mongo extension
#####################################

RUN set -ex; \
    pecl channel-update pecl.php.net && \
    printf "\n" | pecl install redis-4.3.0 && \
    echo "extension=redis.so" > /etc/php.d/redis.ini && \
    printf "\n" | pecl install mongo-1.6.16 && \
    echo "extension=mongo.so" > /etc/php.d/mogno.ini

#####################################
# php ice extension
#####################################

RUN set -ex; \
    cd /etc/yum.repos.d && \
    wget https://zeroc.com/download/Ice/3.5/el6/zeroc-ice-el6.repo && \
    yum install -y ice-php-devel && \
    yum clean all && \
    rm -rf /var/cache/yum

#####################################
# php rdkafka extension
#####################################

RUN set -ex; \
    wget https://github.com/edenhill/librdkafka/archive/v0.11.6.tar.gz && \
    tar -zxf v0.11.6.tar.gz && \
    cd librdkafka-0.11.6 && \
    ./configure && \
    make && \
    make install && \
    printf "\n" | pecl install rdkafka-3.0.5 && \
    echo "extension=rdkafka.so" > /etc/php.d/rdkafka.ini

#####################################
# prepare for working
#####################################

COPY docker-php-entrypoint /usr/local/bin/

RUN set -ex; \
    mkdir -p /data/logs/business/web && \
    chown -R apache:apache /data/logs/business/web && \
    chmod u+x /usr/local/bin/docker-php-entrypoint && \
    sed -i 's/listen\.allowed_clients/;listen\.allowed_clients/' /etc/php-fpm.d/www.conf

ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["php-fpm"]
