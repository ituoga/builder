FROM hashicorp/terraform:latest
RUN apk update && apk add ansible bash
RUN apk add zip php composer php-curl php-zip php-session php-tokenizer php-xml php-dom php-xmlwriter php-fileinfo
WORKDIR /
RUN composer create-project laravel/laravel

