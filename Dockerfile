FROM hashicorp/terraform:latest
RUN apk update && apk add ansible bash
RUN apk add zip php81 composer php81-curl php81-zip php81-session php81-tokenizer php81-xml php81-dom php81-xmlwriter php81-fileinfo 
RUN apk add php81-pgsql
RUN apk add php81-pecl-redis
RUN apk add php81-intl php81-bcmath
RUN apk add php81-session
RUN ln -sf /usr/bin/php81 /usr/bin/php
RUN php -v && sleep 10
WORKDIR /
RUN composer create-project laravel/laravel
WORKDIR /laravel
RUN composer require tymon/jwt-auth
RUN apk add curl wget gnupg
RUN (curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh || wget -t 3 -qO- https://cli.doppler.com/install.sh) | sh
RUN apk add bind
RUN apk add jq
RUN apk add wget unzip
RUN apk add packer --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add rclone
COPY --from=node:14.5.0-alpine /usr/local/bin/node /usr/local/bin/node
COPY --from=node:14.5.0-alpine /usr/local/bin/npm /usr/local/bin/npm