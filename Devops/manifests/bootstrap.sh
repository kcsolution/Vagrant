#!/bin/bash



# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"
 
 
 
# VARIABLES ####################################################################
echo -e "-- Setting global variables\n"
APACHE_CONFIG=/etc/apache2/apache2.conf
VIRTUAL_HOST=localhost
DOCUMENT_ROOT=/var/www/html
 
# BOX ##########################################################################
echo -e "-- Updating packages list\n"
apt-get update -y -qq

#Puppet#########################################################################
apt-get -y install puppet && puppet module install puppetlabs-apache
 
echo "Puppet installed!"
sudo apt-get install ruby-dev
 
# APACHE #######################################################################
echo -e "-- Installing Apache web server\n"
apt-get install -y apache2
 
echo -e "-- Adding ServerName to Apache config\n"
grep -q "ServerName ${VIRTUAL_HOST}" "${APACHE_CONFIG}" || echo "ServerName ${VIRTUAL_HOST}" >> "${APACHE_CONFIG}"
 
echo -e "-- Allowing Apache override to all\n"
sed -i "s/AllowOverride None/AllowOverride All/g" ${APACHE_CONFIG}
 
echo -e "-- Updating vhost file\n"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    ServerName ${VIRTUAL_HOST}
    DocumentRoot ${DOCUMENT_ROOT}
 
    <Directory ${DOCUMENT_ROOT}>
        Options Indexes FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>
 
    ErrorLog ${APACHE_LOG_DIR}/${VIRTUAL_HOST}-error.log
    CustomLog ${APACHE_LOG_DIR}/${VIRTUAL_HOST}-access.log combined
</VirtualHost>
EOF
 
echo -e "-- Restarting Apache web server\n"
service apache2 restart 

# JAVA #########################################################################
echo -e "-- Installing JAVA packages\n"
apt-get install -y openjdk-8-jre > /dev/null 2>&1
apt-get install -y openjdk-8-jdk > /dev/null 2>&1
 
# JENKINS #########################################################################
echo -e "-- Including Jenkins packages\n"
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war | apt-key add - > /dev/null 2>&1
java -jar jenkins.war --httpPort=9090
apt-get update -y -qq
sudo apt-get install jenkins

sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"

 
echo -e "-- Updating packages list\n"
#apt-get update -y -qq


echo -e "-- Installing Jenkins automation server\n"

#apt-get install jenkins -y -qq
#wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
#java -jar jenkins.war --httpPort=9090


 
# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"



