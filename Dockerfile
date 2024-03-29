FROM php:7.3.6-fpm-alpine
MAINTAINER Mai Chan <maiphp@gmail.com>
RUN apk upgrade --update && apk --no-cache add \
    autoconf tzdata openntpd file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc libcurl curl-dev mpc1 mpfr3 gmp libgomp coreutils freetype-dev libjpeg-turbo-dev libltdl libmcrypt-dev libpng-dev openssl-dev libxml2-dev expat-dev zlib-dev libzip-dev \
    && docker-php-ext-install -j$(nproc) iconv mysqli pdo pdo_mysql curl bcmath mbstring json zip opcache \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-configure zip --with-libzip \
 && docker-php-ext-install -j$(nproc) gd 
# TimeZone
RUN cp /usr/share/zoneinfo/Asia/Bangkok /etc/localtime \
&& echo "Asia/Bangkok" >  /etc/timezone
# Install Composer && Assets Plugin
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
&& composer global require --no-progress "fxp/composer-asset-plugin:~1.2" \
&& apk del tzdata \
&& rm -rf /var/cache/apk/*
EXPOSE 9000
CMD ["php-fpm"]