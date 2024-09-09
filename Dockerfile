FROM php:8.3-apache
COPY --from=composer:2.7.6 /usr/bin/composer /usr/local/bin/composer
RUN apt-get update && apt-get install -y \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

RUN apt update && \
     apt install -y \
         libzip-dev \
         && docker-php-ext-install zip pdo pdo_mysql mbstring  bcmath gd mysqli

COPY ./docker/site.conf /etc/apache2/sites-available/
RUN a2dissite 000-default && a2ensite site.conf
RUN a2enmod rewrite && service apache2 restart

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Enable headers module
RUN a2enmod rewrite headers
RUN apt auto-remove -y
RUN service apache2 restart
