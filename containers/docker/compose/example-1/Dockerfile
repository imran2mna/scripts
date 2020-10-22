FROM docker.io/httpd:2.4
MAINTAINER Imran Mohamed <imranen08@gmail.com>
LABEL description="Sleeper Container"
ADD ./files/index.html /usr/local/apache2/htdocs/index.html
ADD ./files/sleeper  /usr/local/bin/
EXPOSE 8080
CMD [ "sleeper" ]
