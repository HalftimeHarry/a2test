FROM gitpod/workspace-mysql

USER root

# install via Ubuntu's APT:
# * Apache - the web server
# * Multitail - see logs live in the terminal
RUN apt-get update \
 && a2dismod mpm_event \
 && apt-get -y install apache2 multitail \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
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

# 1. give write permission to the gitpod-user to apache directories
# 2. let Apache use apache.conf and apache.env.sh from our /workspace/<myproject> folder
RUN chown -R gitpod:gitpod /var/run/apache2 /var/lock/apache2 /var/log/apache2 \
 && echo "include \${GITPOD_REPO_ROOT}/apache.conf" > /etc/apache2/apache2.conf \
 && echo ". \${GITPOD_REPO_ROOT}/apache.env.sh" > /etc/apache2/envvars
 
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
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN echo "extension=sqlsrv.so\nextension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/symfony.ini
