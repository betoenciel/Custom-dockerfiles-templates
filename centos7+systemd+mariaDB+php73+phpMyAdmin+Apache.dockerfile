# Dockerfile Centos7 systemd, MariaDB, PHP 7.3, phpMyAdmin, Apache

FROM centos/systemd

MAINTAINER "Humberto Morales" <betoenciel@gmail.com>

RUN yum -y update
RUN yum -y install nano

RUN yum -y install httpd
RUN systemctl enable httpd.service

RUN yum -y install wget
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
RUN chmod +x mariadb_repo_setup
RUN ./mariadb_repo_setup
RUN yum -y install MariaDB-server
RUN systemctl enable mariadb.service

RUN yum -y install epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 
RUN yum-config-manager --enable remi-php73
RUN yum -y install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd
RUN yum --enablerepo=remi -y install phpmyadmin

RUN yum clean all

# Algunas personalizaciones simples / Some simple customs
RUN rm /etc/httpd/conf.d/welcome.conf
RUN echo 'ServerTokens Prod' >> /etc/httpd/conf/httpd.conf
RUN sed -i "s|Options Indexes FollowSymLinks|Options FollowSymLinks|g" /etc/httpd/conf/httpd.conf
RUN sed -i "s|post_max_size = 8M|post_max_size = 100M|g" /etc/php.ini
RUN sed -i "s|short_open_tag = Off|short_open_tag = On|g" /etc/php.ini
RUN sed -i "s|;date.timezone =|date.timezone = America/Santiago|g" /etc/php.ini
RUN sed -i "14s|Require local|Require all granted|g" /etc/httpd/conf.d/phpMyAdmin.conf
RUN echo '$cfg["Servers"][$i]["hide_db"] = "^(information_schema|mysql|performance_schema|sys)$";' >> /etc/phpMyAdmin/config.inc.php

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/init"]