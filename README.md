# a2test
Start a Drupal 8 project

# Run this after launching instance then update the conf see screenshot.png for example 


# Run this after launching Do not make 9 yet not enough modules ready use first composer command

composer create-project drupal-composer/drupal-project:8.x-dev mysite --no-interaction

//do not use this command
composer create-project drupal/recommended-project mysite

# Mysql set-up

mysql> CREATE DATABASE mysite_db;

mysql> CREATE USER 'mysite_user'@'localhost' IDENTIFIED BY 'MADcap(123)';

mysql> GRANT ALL PRIVILEGES ON mysite_db.* TO 'mysite_user'@'localhost';

# Example how to run the Apache Web Server in Gitpod.io

## Try or Contribute

open [https://gitpod.io#https://github.com/gitpod-io/apache-example](https://gitpod.io#https://github.com/gitpod-io/apache-example)

## What this Example does

* use the Dockerfile to install Apache via apt-get, because in the Dockerfile we have root access
* configure Apache via apache.conf and apache.env.sh from the Gitpod workspace
* have a minimal Apache config in apache.conf
* run Apache as gitpod:gitpod
* follow the Apache logs in the Gitpod Terminal View via multitail
* run apache on port 8080, because as unpreviliged process it can't open port 80

## Terminal Commands to try
* `apachectl start` - start Apache Web Server (it's started automatically on workspace launch)
* `apachectl stop` - stop Apache Web Server
* `gp open /var/log/apache2/access.log` - Open Apache access.log in Gitpod editor
* `gp open /var/log/apache2/error.log` - Open Apache error.log in Gitpod editor
* `multitail /var/log/apache2/access.log -I /var/log/apache2/error.log` - View and follow logs in Terminal
