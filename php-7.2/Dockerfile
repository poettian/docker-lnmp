FROM centos:centos8.1.1911

MAINTAINER Poettian <poettian@gmail.com>

RUN dnf install -y dnf-utils \
    http://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf -y module reset php && \
    dnf -y module enable php:remi-7.2

RUN dnf install -y php-cli \
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
    php-opcache && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENV ICE_DEPS bzip2-devel \
    expat-devel \
    lmdb-devel \
    mcpp-devel \
    openssl-devel \
    php-devel \
    make \
    wget \
    unzip

RUN set -eux; \
    dnf install -y https://zeroc.com/download/ice/3.7/el8/ice-repo-3.7.el8.noarch.rpm; \
    dnf config-manager --set-enabled PowerTools; \
    dnf install -y $ICE_DEPS; \
    cd /usr/local/src; \
    wget https://github.com/zeroc-ice/ice/archive/v3.7.3.zip; \
    unzip v3.7.3.zip; \
    cd /usr/local/src/ice-3.7.3/cpp; \
    make srcs; \
    make install; \
    echo '/opt/Ice-3.7.3/lib64/' > /etc/ld.so.conf.d/ice.conf; \
    ldconfig; \
    cd /usr/local/src/ice-3.7.3/php; \
    make; \
    cp lib/ice.so /usr/lib64/php/modules; \
    echo 'extension=ice.so' > /etc/php.d/50-ice.ini; \
    cp -R lib/* /usr/share/php; \
    dnf remove -y $ICE_DEPS; \
    dnf clean all && \
    rm -rf /var/cache/dnf \
    /usr/local/src/ice-3.7.3 \
    /usr/local/src/v3.7.3.zip \
    /opt/Ice-3.7.3/bin/*

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

RUN set -eux; \
    mkdir -p /data/logs/business/web; \
    chown -R apache:apache /data/logs/business/web

ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["php-fpm"]
