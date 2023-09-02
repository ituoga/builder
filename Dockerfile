FROM alpine:edge
COPY --from=hashicorp/terraform:latest /bin/terraform /bin/terraform
RUN apk update
RUN apk update && apk add ansible bash --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add zip --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add --no-cache libstdc++ gcompat musl-dev musl-utils musl gcc --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add php82 php82-curl php82-zip php82-session php82-tokenizer php82-xml php82-dom php82-xmlwriter php82-fileinfo --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add php82-pgsql --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add php82-pecl-redis --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add php82-intl php82-bcmath --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add php82-session --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add openssl-dev openssl-libs-static libcrypto3 --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add php82-openssl php82-iconv php82-phar --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add icu-dev icu-data-full --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add libintl zip --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add libc6-compat libc-dev libc++-static --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main
RUN ln -sf /usr/bin/php82 /usr/bin/php
RUN wget -O /tmp/composer-setup.php https://getcomposer.org/installer
RUN ldd /usr/bin/php82
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
RUN apk add packer --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add rclone
RUN curl -sL https://unofficial-builds.nodejs.org/download/release/v14.21.3/node-v14.21.3-linux-x64-musl.tar.gz | tar xz -C /usr/local --strip-components=1
RUN apk add php82-pdo php82-simplexml php82-xmlreader php82-sodium php82-ftp php82-gd  --no-cache --repository=https://dl-https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add --no-cache openssl openssh openssh-keygen
RUN wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub
RUN echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories
RUN apk add doppler


# npm install --unsafe-perm=true --allow-root
# prebuild-install --runtime napi
# prebuild-install --runtime napi || prebuild-install || echo "nop"
# RUN npm install --global --production build-tools --unsafe-perm=true --allow-root
