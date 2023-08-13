FROM hashicorp/terraform:latest
RUN apk update && apk add ansible bash
RUN apk add zip php composer php-curl php-zip php-session php-tokenizer php-xml php-dom php-xmlwriter php-fileinfo
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
