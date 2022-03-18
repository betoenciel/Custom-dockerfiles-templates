# Dockerfile Centos7 systemd, PHP 8, Apache, Composer

FROM centos/systemd

MAINTAINER "Humberto Morales" <betoenciel@gmail.com>

RUN yum -y update
RUN yum -y install nano

RUN yum -y install httpd
RUN systemctl enable httpd.service

RUN rm /etc/httpd/conf.d/welcome.conf
RUN echo 'ServerTokens Prod' >> /etc/httpd/conf/httpd.conf
RUN sed -i "s|Options Indexes FollowSymLinks|Options FollowSymLinks|g" /etc/httpd/conf/httpd.conf
RUN sed -i "151s|AllowOverride None|AllowOverride All|g" /etc/httpd/conf/httpd.conf

RUN yum -y install epel-release
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm 
RUN yum-config-manager --enable remi-php80
RUN yum -y install php php-mbstring php-mysqlnd php-zip

RUN yum -y install git
RUN yum -y install wget
RUN yum -y install unzip
RUN yum -y install curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN yum clean all

# Algunas personalizaciones simples / Some simple customs
RUN sed -i "s|short_open_tag = Off|short_open_tag = On|g" /etc/php.ini
RUN sed -i "s|post_max_size = 8M|post_max_size = 100M|g" /etc/php.ini

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]