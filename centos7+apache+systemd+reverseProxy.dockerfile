# Dockerfile Centos 7, Apache, Proxy to api container

FROM centos/systemd

MAINTAINER "Humberto Morales" <betoenciel@gmail.com>

RUN yum -y update
RUN yum -y install nano

RUN yum -y install httpd
RUN systemctl enable httpd.service

# Algunas personalizaciones simples / Some simple customs
RUN rm /etc/httpd/conf.d/welcome.conf
RUN echo 'ServerTokens Prod' >> /etc/httpd/conf/httpd.conf
RUN sed -i "s|Options Indexes FollowSymLinks|Options FollowSymLinks|g" /etc/httpd/conf/httpd.conf
RUN sed -i "151s|AllowOverride None|AllowOverride All|g" /etc/httpd/conf/httpd.conf
RUN echo $'<VirtualHost *:80>\n\tServername localhost\n\tProxyPreserveHost On\n\tProxyRequests off\n\t<Proxy *>\n\t\tOrder deny,allow\n\t\tAllow from all\n\t</Proxy>\n\tProxyPass /api http://172.20.0.3/\n\tProxyPassReverse /api http://172.20.0.3/\n</VirtualHost>' >> /etc/httpd/conf.d/api.conf

RUN yum -y install git

RUN yum clean all

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]

