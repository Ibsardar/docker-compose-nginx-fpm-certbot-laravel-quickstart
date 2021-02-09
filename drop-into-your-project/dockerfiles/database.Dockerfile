FROM mysql:8.0
LABEL MAINTAINER="IBRAHIM"
ARG NGINX_ROOT
# only ENV vars can be used in ENTRYPOINT, so we have to transfer it from ARG to ENV
ENV E_NGINX_ROOT $NGINX_ROOT
ENV MYSQL_ALLOW_EMPTY_PASSWORD='yes'


# make the nginx root folder and copy needed server files for building
RUN mkdir -p ${NGINX_ROOT}/server
COPY ./server/init_database.sh ${NGINX_ROOT}/server/init_database.sh
COPY ./server/init_database.sql ${NGINX_ROOT}/server/init_database.sql


# allow execute on shell script and run it
RUN chmod +x ${NGINX_ROOT}/server/init_database.sh
# comment out for default entrypoint
#ENTRYPOINT sh "${E_NGINX_ROOT}/server/init_database.sh"


EXPOSE 3306