FROM centos:7.6.1810

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
    php-pecl-mongodb \
    php-mysqlnd \
    php-pdo \
    php-pecl-redis \
    php-opcache \
    php-devel

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

RUN set -eux; \
    yum install -y wget; \
    wget https://zeroc.com/download/GPG-KEY-zeroc-release-B6391CB2CFBA643D; \
    rpm --import GPG-KEY-zeroc-release-B6391CB2CFBA643D; \
    cd /etc/yum.repos.d; \
    wget https://zeroc.com/download/Ice/3.7/el7/zeroc-ice3.7.repo; \
    cd /usr/local/src; \
    wget https://github.com/zeroc-ice/ice/archive/v3.7.0.zip; \
    yum install -y unzip; \
    unzip v3.7.0.zip



RUN yum install -y bzip2-devel \
    bzip2 \
    expat-devel \
    lmdb-devel \
    mcpp-devel \
    openssl-devel \
    centos-release-scl && \
    yum install -y devtoolset-7

RUN source scl_source enable devtoolset-7; \
    set -eux; \
    cd /usr/local/src/ice-3.7.0/cpp; \
    make V=1 -j8 srcs; \
    make install

RUN source scl_source enable devtoolset-7; \
    set -eux; \
    echo '/opt/Ice-3.7.0/lib64/' > /etc/ld.so.conf.d/ice.conf; \
    ldconfig; \
    export ICE_HOME=/opt/Ice-3.7.0; \
    export PATH=$ICE_HOME/bin:$PATH; \
    export PATH; \
    cd /usr/local/src/ice-3.7.0/php; \
    make; \
    cp lib/ice.so /usr/lib64/php/modules; \
    echo 'extension=ice.so' > /etc/php.d/10-ice.ini; \
    cp -R lib/* /usr/share/php

RUN rm -rf /usr/local/src/v3.7.0.zip \
    /usr/local/src/ice-3.7.0 && \
    yum clean all && \
    rm -rf /var/cache/yum

EXPOSE 9000

CMD ["php-fpm"]
