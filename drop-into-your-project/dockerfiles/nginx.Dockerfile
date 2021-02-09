FROM nginx:1.18
LABEL MAINTAINER="IBRAHIM"
ARG NGINX_ROOT
# only ENV vars can be used in ENTRYPOINT, so we have to transfer it from ARG to ENV
ENV E_NGINX_ROOT $NGINX_ROOT


# make the nginx root folder and copy needed server files for building
RUN mkdir -p ${NGINX_ROOT}/server
COPY ./server/init_nginx.sh ${NGINX_ROOT}/server/init_nginx.sh


# set permissions of root folder
RUN find ${NGINX_ROOT} -type f -exec chmod 664 {} \;
RUN find ${NGINX_ROOT} -type d -exec chmod 775 {} \;


# allow execute on shell script and run it
RUN chmod +x ${NGINX_ROOT}/server/init_nginx.sh
ENTRYPOINT sh "${E_NGINX_ROOT}/server/init_nginx.sh"