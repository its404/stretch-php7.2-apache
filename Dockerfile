FROM php:7.2.19-apache-stretch

WORKDIR /app

ENV PHP_XDEBUG_REMOTE_HOST=${PHP_XDEBUG_REMOTE_HOST:-docker.for.mac.localhost}
ENV PHP_XDEBUG_IDEKEY=${PHP_XDEBUG_IDEKEY:-XDEBUG_ECLIPSE}
ENV PHP_XDEBUG_REMOTE_ENABLE=${PHP_XDEBUG_REMOTE_ENABLE:-on}

LABEL Maintainer="Ben <benwk424@gmail.com>"

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install \
    gnupg2 && \
    apt-key update && \
    apt-get update && \
    apt-get -y install \
    g++ \
    git \
    curl \
    imagemagick \
    libcurl3-dev \
    libicu-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libpq-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    zlib1g-dev \
    mysql-client \
    openssh-client \
    nano \
    unzip \
    libcurl4-openssl-dev \
    libssl-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PHP extensions required for Yii 2.0 Framework
RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-install \
    soap \
    zip \
    curl \
    bcmath \
    exif \
    gd \
    iconv \
    intl \
    mbstring \
    opcache \
    pdo_mysql \
    pdo_pgsql

# Install PECL extensions
# see http://stackoverflow.com/a/8154466/291573) for usage of `printf`
RUN printf "\n" | pecl install \
    imagick \
    mongodb && \
    docker-php-ext-enable \
    imagick \
    mongodb

# Check if Xdebug extension need to be compiled
RUN pecl install xdebug-2.6.0 \
    && docker-php-ext-enable xdebug

# Environment settings
ENV PATH=/app:/app/vendor/bin:/root/.composer/vendor/bin:$PATH \
    TERM=linux \
    VERSION_PRESTISSIMO_PLUGIN=^0.3.7 \
    COMPOSER_ALLOW_SUPERUSER=1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer.phar \
    --install-dir=/usr/local/bin

# Enable mod_rewrite for images with apache
RUN if command -v a2enmod >/dev/null 2>&1; then \
    a2enmod rewrite headers \
    ;fi

# Install Yii framework bash autocompletion
RUN curl -L https://raw.githubusercontent.com/yiisoft/yii2/master/contrib/completion/bash/yii \
    -o /etc/bash_completion.d/yii

COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
