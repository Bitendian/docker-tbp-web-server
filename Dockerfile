FROM php:8.2.24-apache

ENV ACCEPT_EULA=Y

RUN apt-get -y --fix-missing update && apt-get -y --fix-missing upgrade && ACCEPT_EULA=Y apt-get -y --fix-missing install \
vim \
joe \
git \
curl \
libpng-dev \
libcurl4 \
libcurl4-openssl-dev \
libfreetype6 \
libfreetype6-dev \
libpng-dev \
unzip \
zip \
libzip-dev \
zlib1g-dev \
apt-transport-https \
mariadb-client \
libapache2-mod-xsendfile \
locales \
gettext \
gnupg \
&& apt-get -y --fix-missing --no-install-recommends install \
libmagickwand-dev


# Packages for MicrosoftSQL Server Connection
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get -y --fix-missing update && apt-get -y --fix-missing upgrade && ACCEPT_EULA=Y apt-get -y --fix-missing install \
libonig-dev \
unixodbc \
unixodbc-dev \
msodbcsql17

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Other PHP7 Extensions
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring pdo

RUN docker-php-ext-install curl
RUN docker-php-ext-install gettext

RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

# Configure image magick for GD extension
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick
RUN docker-php-ext-configure gd
RUN docker-php-ext-install gd

# Enable apache modules
RUN a2enmod rewrite headers ssl xsendfile

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "max_input_vars = 10000;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 512M;" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size = 512M;" >> /usr/local/etc/php/conf.d/uploads.ini

RUN ln -s /usr/local/bin/php /usr/bin/php

# Configure MicrosoftSQL Server packages
RUN pecl install sqlsrv pdo_sqlsrv

RUN docker-php-ext-enable sqlsrv pdo_sqlsrv
RUN sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1.0/' /etc/ssl/openssl.cnf

# Set usual locales
RUN sed -i 's/# ca_ES.UTF-8 UTF-8/ca_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# Setup apache default virtual host
COPY default.conf /etc/apache2/sites-enabled/000-default.conf

COPY .gitconfig /root/.gitconfig

# timezone
ENV TZ=Europe/Madrid

# for container
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# for PHP especifically
RUN printf '[PHP]\ndate.timezone = "%s"\n' "$TZ" > /usr/local/etc/php/conf.d/tzone.ini
