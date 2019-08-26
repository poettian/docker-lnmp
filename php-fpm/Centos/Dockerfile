FROM centos:centos7.5.1804

MAINTAINER Poettian <poettian@gmail.com>

RUN yum install -y epel-release \
    yum-utils \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php72 \
    && yum install -y php-cli \
    php-fpm \
    php-bcmath \
    php-xml \
    php-gd \
    php-pecl-igbinary \
    php-imap \
    php-intl \
    php-ldap \
    php-mbstring \
    php-pecl-memcached \
    php-pecl-mongodb \
    php-pecl-msgpack \
    php-mysqlnd \
    php-pdo \
    php-pgsql \
    php-pecl-redis \
    php-soap \
    php-opcache \
    php-pecl-xdebug \
    php-process \
    php-sodium \
    php-tidy \
    php-pecl-zip \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY docker-php-entrypoint /usr/local/bin/

RUN set -eux; \
    [ ! -d /run/php-fpm ]; \
    mkdir /run/php-fpm; \
    chmod u+x /usr/local/bin/docker-php-entrypoint; \
    cd /etc/; \
    sed -i 's/include=.*\.conf//;$a include=/etc/php-fpm.d/*.conf' php-fpm.conf; \
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
