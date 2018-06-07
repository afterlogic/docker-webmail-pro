FROM ubuntu:trusty
MAINTAINER AfterLogic Support <support@afterlogic.com>

# installing packages and dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
              wget \
              unzip \
              supervisor \
              apache2 \
              libapache2-mod-php5 \
              mysql-server \
              php5 \
              php5-common \
              php5-curl \
              php5-fpm \
              php5-cli \
              php5-mysqlnd \
              php5-mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# adding configuration files and scripts
COPY start-apache2.sh /start-apache2.sh
COPY start-mysqld.sh /start-mysqld.sh
COPY run.sh /run.sh
COPY my.cnf /etc/mysql/conf.d/my.cnf
COPY supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
COPY supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
RUN chmod 755 /*.sh

# deleting default database
RUN rm -rf /var/lib/mysql/*

# setting up default apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# downloading and setting up webmail
RUN rm -rf /tmp/alwm && \
    mkdir -p /tmp/alwm && \
    wget -P /tmp/alwm http://www.afterlogic.com/download/webmail-pro-php.zip && \
    unzip -q /tmp/alwm/webmail-pro-php.zip -d /tmp/alwm/
    
RUN rm -rf /var/www/html && \
    mkdir -p /var/www/html && \
    cp -r /tmp/alwm/webmail/* /var/www/html && \
    rm -rf /var/www/html/install && \
    chown www-data.www-data -R /var/www/html && \
    chmod 0777 -R /var/www/html/data
    
RUN rm -f /var/www/html/afterlogic.php
COPY afterlogic.php /var/www/html/afterlogic.php
RUN mkdir /var/www/html/data/plugins/trial-license-key
COPY plugin.php /var/www/html/data/plugins/trial-license-key/index.php
RUN sed -i \
    -e 's|return array(|return array( "plugins.trial-license-key" => true,|' \
    /var/www/html/data/settings/config.php
RUN rm -rf /tmp/alwm

# setting php configuration values
ENV PHP_UPLOAD_MAX_FILESIZE 64M
ENV PHP_POST_MAX_SIZE 128M

# adding mysql volumes
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306
CMD ["/run.sh"]
