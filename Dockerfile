FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    nginx-full \
    git curl unzip \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev \
    supervisor gettext-base \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN chmod -R 777 storage bootstrap/cache

RUN mkdir -p /var/log/nginx
RUN mkdir -p /var/run

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf.template /etc/nginx/conf.d/default.conf.template

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
