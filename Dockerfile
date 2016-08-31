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

# 更改时区
RUN echo 'y'|cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 依赖环境安装
RUN rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm && yum install python-pip -y && easy_install supervisor && mkdir /var/log/supervisor/

#安装lamp环境
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm && \
   yum -y install httpd && \
   yum -y install libmysqlclient mysql55w mysql55w-server && \
   yum -y install php55w php55w-fpm  php55w-gd  php55w-mysql 
#安装crontab服务
RUN yum -y install vixie-cron crontabs tar 

# 配置supervisor
COPY supervisord.conf /etc/supervisord.conf

COPY run.sh start-httpd.sh start-mysqld.sh start-php5.sh create_mysql_admin_user.sh /
RUN chmod +x /run.sh /start-httpd.sh /start-php5.sh /start-mysqld.sh /create_mysql_admin_user.sh

RUN yum clean all

VOLUME /var/lib/mysql

EXPOSE 80 3306

CMD ["/run.sh"]