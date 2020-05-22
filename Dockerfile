FROM debian:buster

MAINTAINER nesterivan1992@gmail.com

WORKDIR /var/www

RUN apt-get update && \
    apt-get install -qy \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
    apt-transport-https lsb-release ca-certificates  wget


RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list &&  apt-get update


RUN apt-get update && \
    apt-get install -qy \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
     php7.3 \
     php7.3-fpm \
     php7.3-cli \
     php7.3-gd \
     php7.3-memcached \
     php7.3-curl \
     php7.3-common \
     php7.3-geoip \
     php7.3-intl \
     php7.3-mbstring \
     php7.3-xml \
     php7.3-mysql \
     php7.3-zip \
     php7.3-bcmath \
     php7.3-xsl


# Add entrypoint script
ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY www.conf  /etc/php/7.3/fpm/pool.d/

RUN apt-get update && \
    apt-get install -qy \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
    curl git  net-tools  procps


RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require --no-progress "fxp/composer-asset-plugin:~1.4.2"

RUN apt-get update && \
    apt-get install -qy \
    -o APT::Install-Recommend=false -o APT::Install-Suggests=false \
      jpegoptim  optipng  pngquant  gifsicle webp npm

RUN npm install -g svgo

RUN mkdir -p /var/run/php/
ENTRYPOINT ["entrypoint.sh"]
CMD [ "php-fpm7.3", "-F", "-R", "-y", "/etc/php/7.3/fpm/php-fpm.conf" ]


