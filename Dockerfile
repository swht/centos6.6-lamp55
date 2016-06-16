##################################################
#Author:qingbo.song                              #
#Date:2016.06.16                                 #
#E-mail:qingbo.song@apicloud.com                 #
#Comment: APICloud模板Store centos6.5镜像模板文件#
#python2.7.11 httpd-2.2.15 mysql55w php55w       #
#Version:V 1.0                                   #
##################################################

FROM index.alauda.cn/library/centos:6.6
   
# 镜像的作者  
MAINTAINER Qingbo Song "qingbo.song@apicloud.com"

# 依赖环境安装
RUN yum install supervisor -y 

#安装lamp环境
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm && \
   yum -y install httpd && \
   yum -y install libmysqlclient mysql55w mysql55w-server && \
   yum -y install php55w php55w-fpm  php55w-gd  php55w-mysql 

# 配置supervisor
RUN mkdir /etc/supervisor.d && echo_supervisord_conf > /etc/supervisord.conf && echo "files = /etc/supervisor.d/*.conf" >> /etc/supervisord.conf

COPY run.sh start-apache2.sh start-mysqld.sh create_mysql_admin_user.sh /
COPY supervisord-apache2.conf supervisord-mysqld.conf /etc/supervisor.d
RUN chmod +x /run.sh /start-apache2.sh /start-mysqld.sh /create_mysql_admin_user.sh

CMD ["/run.sh"]