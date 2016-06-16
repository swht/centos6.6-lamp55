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
RUN yum install unzip zlib zlib-devel openssl-devel tar g++ gcc gcc-c++ file -y 

# Install python2.7.11
ADD Python-2.7.11.tgz /opt/
RUN \
   cd /opt/Python-2.7.11 && ./configure --prefix=/usr/local/python2.7.11 && make && make install && \
   mv /usr/bin/python /usr/bin/python_old && ln -s /usr/local/python2.7.11/bin/python /usr/bin/ && ln -s /usr/local/python2.7.11/bin/* /usr/local/bin && \
   sed -i "s/python/python2.6/g" /usr/bin/yum

# 源码安装setuptools和pip
ADD setuptools-23.0.0.tar.gz /opt/
RUN \
   cd /opt/setuptools-23.0.0 && python setup.py build  && python setup.py install 
ADD pip-8.1.2.tar.gz /opt/
RUN \
   cd /opt/pip-8.1.2 && python setup.py build  && python setup.py install

# 源码安装MySQLdb库
#RUN yum install mysql mysql-devel mysql-connector-odbc gcc python-devel -y
#ADD MySQLdb1-master.zip /opt/
#RUN \
#   cd /opt/ && unzip -o MySQLdb1-master.zip && cd MySQLdb1-master && \
#   sed -i "s/threadsafe = Ture/threadsafe = False/g" site.cfg && \
#   echo "mysql_config = /usr/bin/mysql_config" >> site.cfg && \
#   python setup.py build && python setup.py install && ln -s /usr/local/python2.7.11/bin/pip /usr/bin/

# 安装supervisor
RUN ln -s /usr/local/python2.7.11/bin/pip /usr/bin/ && pip install supervisor

#安装lamp环境
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm && \
   yum -y install httpd && \
   yum -y install libmysqlclient mysql55w mysql55w-server && \
   yum -y install php55w php55w-fpm  php55w-gd  php55w-mysql 

COPY run.sh start-apache2.sh start-mysqld.sh create_mysql_admin_user.sh /
COPY supervisord-apache2.conf supervisord-mysqld.conf /etc/supervisor/conf.d/
RUN chmod +x /run.sh /start-apache2.sh /start-mysqld.sh /create_mysql_admin_user.sh
# clear code
RUN \
   yum -y remove unzip tar && \
   yum -y remove gcc cloog-ppl cpp glibc-devel glibc-headers kernel-headers libgomp ppl && \
   yum -y remove libstdc++-devel gcc-c++ && \ 
   rm -fr /opt/*

CMD ["/bin/bash"]