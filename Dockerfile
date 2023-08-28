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

RUN apk add --no-cache libstdc++ gcompat musl-dev musl-utils musl gcc
RUN apk add php82-pdo php82-simplexml php82-xmlreader php82-sodium php82-ftp php82-gd
USER root

WORKDIR /tmp
RUN apk add zstd
RUN wget https://github.com/indygreg/python-build-standalone/releases/download/20230726/cpython-3.10.12+20230726-x86_64_v4-unknown-linux-musl-noopt-full.tar.zst
RUN zstd -d cpython*.zst && tar xf cpython*.tar
# RUN mv python/install /python3.10
RUN mv python/install /python3.10 && cp -r /python3.10/* /usr && cp -r /python3.10/* /usr/local && rm -rf /python3.10
RUN rm -rf /tmp/cpython-3.10.12+20230726-x86_64_v4-unknown-linux-musl-noopt-full.tar
RUN apk add alpine-sdk make g++
RUN curl -sL https://unofficial-builds.nodejs.org/download/release/v14.21.3/node-v14.21.3-linux-x64-musl.tar.gz | tar xz -C /usr/local --strip-components=1
RUN npm install -g node-gyp
# RUN mv /usr/local/bin/node /usr/local/bin/node2
RUN echo "#!/bin/bash" > /usr/local/bin/hack.sh
RUN echo "echo wrapper" >> /usr/local/bin/hack.sh
RUN echo "source /.entrypoint.env" >> /usr/local/bin/hack.sh
RUN echo "export PATH=/python3.10/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/sbin:/bin" >> /usr/local/bin/hack.sh
RUN echo "python --version"
RUN echo "exec /bin/bash \"\$@\"" >> /usr/local/bin/hack.sh
RUN chmod +x /usr/local/bin/hack.sh

RUN mv /usr/local/bin/npm /usr/local/bin/npm2
RUN echo "#!/bin/bash" > /usr/local/bin/npm
RUN echo "export PATH=/python3.10/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/sbin:/bin" >> /usr/local/bin/npm
RUN echo "export PYTHON=/python3.10/bin/python3" >> /usr/local/bin/npm
RUN echo "export npm_config_script_shell=/usr/local/bin/hack.sh" >> /usr/local/bin/npm
RUN echo "python --version" >> /usr/local/bin/npm
RUN echo "/usr/local/bin/npm2 config set python /python3.10/bin/pytnon3" >> /usr/local/bin/npm
RUN echo "printenv > /.entrypoint.env" >> /usr/local/bin/npm
RUN echo "/usr/local/bin/npm2 \$@ --python=/usr/bin/python" >> /usr/local/bin/npm
RUN chmod +x /usr/local/bin/npm

# RUN echo "#!/bin/bash" > /usr/local/bin/node
# RUN echo "PATH=/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/sbin:/bin /usr/local/bin/node2 \$@" >> /usr/local/bin/node
# RUN chmod +x /usr/local/bin/node
WORKDIR /laravel
ENV PATH=/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/sbin:/bin
RUN echo "#!/bin/bash" > /entrypoint.sh
RUN echo "export PYTHON=/python3.10/bin/python3" >> /entrypoint.sh
RUN echo "printenv" >> /.entrypoint.env
RUN echo "export npm_config_script_shell=/usr/local/bin/hack.sh" > /entrypoint.sh
RUN echo "exec /bin/bash \"\$@\"" > /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV npm_config_script_shell=/usr/local/bin/hack.sh
ENTRYPOINT [ "/entrypoint.sh" ]