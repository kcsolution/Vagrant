#!/usr/bin/env bash

export LD_LIBRARY_PATH=/opt/oracle/instantclient
export ORACLE_HOME=/opt/oracle/instantclient

echo "Instantclient path: instantclient,/opt/oracle/instantclient"

sudo pecl install oci8

sudo echo "extension=oci8.so" >> /etc/php5/fpm/php.ini
sudo echo "extension=oci8.so" >> /etc/php5/cli/php.ini

sudo service php5-fpm restart
sudo service nginx restart