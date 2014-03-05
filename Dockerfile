FROM ubuntu:13.10
MAINTAINER Julian Shen <julianshen@gmail.com>
ENV MYSQL_ROOT_PASS 12345
ENV OWNCLOUD_ARCHIVE owncloud-6.0.2.tar.bz2
RUN apt-get update
RUN echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
RUN apt-get -y install mysql-server
RUN apt-get -y install php5
RUN apt-get -y install apache2 libapache2-mod-php5
RUN apt-get -y install php5-gd php5-json php5-mysql php5-curl
RUN apt-get -y install php5-intl php5-mcrypt php5-imagick
RUN apt-get -y install wget curl
RUN wget -q -O - http://download.owncloud.org/community/$OWNCLOUD_ARCHIVE | tar jx -C /var/www
RUN chown -R www-data:www-data /var/www/owncloud
RUN a2enmod ssl rewrite
ADD owncloud.conf /etc/apache2/sites-available/
RUN a2ensite owncloud
EXPOSE :443 :80
ADD start.sh /
CMD sh start.sh
