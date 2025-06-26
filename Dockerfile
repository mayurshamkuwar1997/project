FROM mysql
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=loginwebapp
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=123456
COPY init.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
