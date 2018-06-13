FROM docker.hypernode.com/byteinternet/hypernode-docker:latest
MAINTAINER frosit <fabio@frosit.nl>

# pass env variables
ARG AUTH_APP_PWD
ARG AUTH_ROOT_PWD

# Add keys
ADD ./env/etc/.ssh /data/web/.ssh
RUN cp /data/web/.ssh/authorized_keys /root/.ssh/authorized_keys

# change passwds
RUN echo "root:${AUTH_ROOT_PWD:-root}" | chpasswd && echo "app:${AUTH_APP_PWD:-app}" | chpasswd

# Give sudo permissions
RUN usermod -aG sudo app

# Add env file
ADD ./.env /data/web/.env
RUN echo "if [ -f /data/web/.env ]; then export \$(egrep -v '^#' /data/web/.env | xargs); fi" >> /data/web/.bashrc

# Add aliases
ADD ./env/etc/.bash_aliases /data/web/.bash_aliases

# Add profile
#ADD ./env/etc/.bash_profile /data/web/.bash_profile

# Add magerun
ADD ./env/etc/.n98-magerun.yaml /data/web/.n98-magerun.yaml
ADD ./env/etc/.n98-magerun /data/web/.n98-magerun

# Add composer
ADD ./env/etc/.composer /data/web/.composer

# Add provision
ADD ./env/etc/.provision /data/web/.provision

# Set permissions
RUN chown -R app:app /data/web/.composer /data/web/.env /data/web/.n98-magerun /data/web/.n98-magerun.yaml /data/web/.ssh /data/web/.bash_aliases /data/web/.provision