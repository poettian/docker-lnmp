FROM centos:centos8.1.1911

MAINTAINER Poettian <poettian@gmail.com>

RUN yum install -y epel-release \
    yum-utils \
    http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php72 && \
    yum install -y php-cli \
    php-fpm \
    php-bcmath \
    php-xml \
    php-gd \
    php-mbstring \
    php-imap \
    php-intl \
    php-ldap \
    php-mysqlnd \
    php-pdo \
    php-soap \
    php-process \
    php-sodium \
    php-tidy \
    php-pecl-redis5 \
    php-pecl-mongodb \
    php-pecl-msgpack \
    php-pecl-mcrypt \
    php-pecl-igbinary \
    php-pecl-xdebug \
    php-pecl-swoole4 \
    php-opcache \
    yum clean all && \
    rm -rf /var/cache/yum

ENV ICE_DEPS bzip2-devel \
    expat-devel \
    lmdb-devel \
    mcpp-devel \
    openssl-devel

RUN set -eux; \
    yum install -y $ICE_DEPS \
    wget \
    unzip \
    php-devel; \
    cd /usr/local/src; \
    wget https://github.com/zeroc-ice/ice/archive/v3.7.0.zip; \
    unzip v3.7.0.zip; \
    cd /usr/local/src/ice-3.7.0/cpp; \
    make srcs; \
    make install; \
    cd /usr/local/src/ice-3.7.0/php; \
    make; \
    cp lib/ice.so /usr/lib64/php/modules; \
    echo 'extension=ice.so' > /etc/php.d/50-ice.ini; \
    cp -R lib/* /usr/share/php; \
    yum erase -y $ICE_DEPS \
    wget \
    unzip \
    php-devel; \
    yum clean all && \
    rm -rf /var/cache/yum \
    /usr/local/src/ice-3.7.0 \
    /usr/local/src/v3.7.0.zip

COPY docker-php-entrypoint /usr/local/bin/

RUN set -eux; \
    [ ! -d /run/php-fpm ]; \
    mkdir /run/php-fpm; \
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
