FROM php:8.1-apache-bullseye

ENV dir /var/www
RUN mkdir -p ${dir}
WORKDIR ${dir}

RUN apt-get -y update && \
  apt-get -y install \
  ca-certificates apt-transport-https software-properties-common dumb-init git

RUN chmod o+rw ${dir}/html

ENTRYPOINT ["dumb-init", "--"]

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
  php composer-setup.php && \
  php -r "unlink('composer-setup.php');"

COPY composer.json ${dir}
COPY composer.lock ${dir}

RUN php composer.phar update

COPY src ${dir}/html
