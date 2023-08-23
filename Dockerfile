FROM hashicorp/terraform:latest
RUN apk update && apk add ansible bash
RUN apk add zip php82 php82-curl php82-zip php82-session php82-tokenizer php82-xml php82-dom php82-xmlwriter php82-fileinfo 
RUN apk add php82-pgsql
RUN apk add php82-pecl-redis
RUN apk add php82-intl php82-bcmath
RUN apk add php82-session
RUN apk add php82-openssl php82-iconv php82-phar
RUN ln -sf /usr/bin/php82 /usr/bin/php
RUN wget -O /tmp/composer-setup.php https://getcomposer.org/installer
RUN php -r "if (hash_file('sha384', '/tmp/composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php /tmp/composer-setup.php 
RUN php -r "unlink('/tmp/composer-setup.php');"
RUN mv composer.phar /usr/bin/composer
WORKDIR /
RUN composer create-project laravel/laravel laravel --no-scripts
WORKDIR /laravel
RUN composer require tymon/jwt-auth
RUN apk add curl wget gnupg
RUN (curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh || wget -t 3 -qO- https://cli.doppler.com/install.sh) | sh
RUN apk add bind
RUN apk add jq
RUN apk add wget unzip
RUN apk add packer --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add rclone
RUN curl -sL https://unofficial-builds.nodejs.org/download/release/v14.21.3/node-v14.21.3-linux-x64-musl.tar.gz | tar xz -C /usr/local --strip-components=1
RUN apk add --no-cache libstdc++ gcompat musl-dev musl-utils musl gcc
RUN apk add php82-pdo php82-simplexml php82-xmlreader php82-sodium php82-ftp php82-gd
USER root
COPY --from=python:3.10-alpine /usr/local/bin/python /usr/local/bin/python3.10
COPY --from=python:3.10-alpine /usr/local/bin/pip3 /usr/local/bin/pip3.10
COPY --from=python:3.10-alpine /usr/local/lib/libpython3.10.so.1.0 /usr/local/lib/libpython3.10.so.1.0
RUN ln -sf /usr/loca/bin/python3.10 /usr/bin/python
RUN npm config set python /usr/local/bin/python3.10