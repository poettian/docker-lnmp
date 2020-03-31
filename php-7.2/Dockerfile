FROM centos:centos8.1.1911

MAINTAINER Poettian <poettian@gmail.com>

USER root

RUN dnf install -y dnf-utils \
    wget \
    unzip && \
    dnf clean all && \
    rm -rf /var/cache/dnf

#####################################
# basic php-cli php-fpm and extensions
#####################################

RUN dnf install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
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

RUN set -ex; \
    dnf install -y gcc \
    gcc-c++ \
    make \
    cyrus-sasl-devel && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN dnf config-manager --set-enabled PowerTools

RUN set -ex; \
    dnf install -y php-pear \
    php-devel && \
    pecl channel-update pecl.php.net && \
    dnf clean all && \
    rm -rf /var/cache/dnf

#####################################
# php ice extension
#####################################

ENV ICE_DEPS bzip2-devel \
    expat-devel \
    lmdb-devel \
    mcpp-devel \
    openssl-devel

RUN set -ex; \
    dnf install -y https://zeroc.com/download/ice/3.7/el8/ice-repo-3.7.el8.noarch.rpm && \
    dnf install -y $ICE_DEPS && \
    cd /usr/local/src && \
    wget https://github.com/zeroc-ice/ice/archive/v3.7.3.zip && \
    unzip v3.7.3.zip && \
    cd /usr/local/src/ice-3.7.3/cpp && \
    make srcs && \
    make install && \
    echo '/opt/Ice-3.7.3/lib64/' > /etc/ld.so.conf.d/ice.conf && \
    ldconfig && \
    cd /usr/local/src/ice-3.7.3/php && \
    make && \
    cp lib/ice.so /usr/lib64/php/modules && \
    echo 'extension=ice.so' > /etc/php.d/50-ice.ini && \
    cp -R lib/* /usr/share/php && \
    dnf remove -y $ICE_DEPS && \
    dnf clean all && \
    rm -rf /var/cache/dnf \
    /usr/local/src/ice-3.7.3 \
    /usr/local/src/v3.7.3.zip \
    /opt/Ice-3.7.3/bin/*

#####################################
# php rdkafka extension
#####################################

RUN set -ex; \
    cd ~ && \ 
    wget https://github.com/edenhill/librdkafka/archive/v1.3.0.tar.gz && \
    tar -zxf v1.3.0.tar.gz && \
    cd librdkafka-1.3.0 && \
    ./configure --install-deps && \
    make && \
    make install && \
    rm -rf ~/librdkafka-1.3.0 \
    ~/v1.3.0.tar.gz

RUN pecl install rdkafka-4.0.3 && \
    echo "extension=rdkafka.so" > /etc/php.d/50-rdkafka.ini

#####################################
# prepare for working
#####################################

RUN set -ex; \
    mkdir -p /data/logs/business/web && \
    chown -R apache:apache /data/logs/business/web

COPY docker-php-entrypoint /usr/local/bin/

RUN chmod u+x /usr/local/bin/docker-php-entrypoint

#RUN set -eux; \
#    [ ! -d /run/php-fpm ]; \
#    mkdir /run/php-fpm; \
#    cd /etc/; \
#    sed -i 's/include=.*\.conf//;$a include=/etc/php-fpm.d/*.conf' php-fpm.conf; \
#    sed -i 's/listen\.allowed_clients/;listen\.allowed_clients/' php-fpm.d/www.conf; \
#    { \
#        echo '[global]'; \
#        echo 'daemonize = no'; \
#        echo; \
#        echo '[www]'; \
#        echo 'listen = 9000'; \
#    } | tee php-fpm.d/zz-docker.conf


ENTRYPOINT ["docker-php-entrypoint"]

EXPOSE 9000

CMD ["php-fpm"]
