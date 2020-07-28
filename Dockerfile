FROM php:7.1.23-apache

USER root

RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && chmod ugo+x /usr/local/bin/composer


RUN apt-get update && apt-get install -y \
  vim \
  git \
  unzip \
  wget \
  curl \
  libmcrypt-dev \
  libcurl4-openssl-dev \
  mysql-client \
  nodejs \
  libxml2-dev \
  libldb-dev libldap2-dev \
  build-essential \
  freetds-bin \
  freetds-dev \
  apt-transport-https

#Microsoft Drivers for PHP for SQL Server: https://github.com/Microsoft/msphpsql
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get install -y locales \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && locale-gen

RUN apt-get -y update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql
RUN apt-get install -y unixodbc-dev

RUN pear config-set php_ini `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` system
RUN pecl install
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN echo "extension=sqlsrv.so\nextension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/symfony.ini

# Install update instance
RUN apt-get -y update \
    && apt-get install curl -y \
    && apt-get install apt-transport-https \
    && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get -y update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Create sqlsetup directory
RUN mkdir -p /usr/src/sqlsetup
WORKDIR /usr/src/sqlsetup

# Bundle sqlsetup source
COPY . /usr/src/sqlsetup

# Grant permissions for the import-data script to be executable
RUN chmod +x /usr/src/sqlsetup/setup-db.sh

CMD /bin/bash ./setup-db.sh
