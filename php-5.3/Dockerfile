FROM centos:centos6.10

MAINTAINER Poettian <poettian@gmail.com>

RUN yum install -y epel-release \
    php-cli \
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

ENV PHP_DEPS gcc \
    make \
    php-devel \
    php-pear \
    libmcrypt \
    openssl-devel \
    wget

RUN set -eux; \
    yum install -y $PHP_DEPS; \
    printf "\n" | pecl install mongo-1.6.16; \
    echo 'extension=mongo.so' > /etc/php.d/mogno.ini; \
    printf "\n" | pecl install redis-4.3.0; \
    echo 'extension=redis.so' > /etc/php.d/redis.ini; \
    cd /etc/yum.repos.d; \
    wget https://zeroc.com/download/Ice/3.5/el6/zeroc-ice-el6.repo; \
    yum install -y ice-php-devel; \
    yum clean all; \
    rm -rf /var/cache/yum

COPY docker-php-entrypoint /usr/local/bin/

RUN set -eux; \
    chmod u+x /usr/local/bin/docker-php-entrypoint; \
    cd /etc/; \
    sed -i 's/include=.*\.conf//;$a include=/etc/php-fpm.d/*.conf' php-fpm.conf; \
    sed -i 's/listen\.allowed_clients/;listen\.allowed_clients/' php-fpm.d/www.conf; \
    { \
        echo '[global]'; \
        echo 'daemonize = no'; \
        echo; \
        echo '[www]'; \
        echo 'listen = 9000'; \
    } | tee php-fpm.d/zz-docker.conf

ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["php-fpm"]
