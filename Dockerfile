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
RUN wget https://releases.hashicorp.com/packer/1.9.2/packer_1.9.2_linux_amd64.zip /tmp && unzip packer_1.9.2_linux_amd64.zip && mv packer /usr/loca/bin && rm -rf packer_1.9.2_linux_amd64.zip
