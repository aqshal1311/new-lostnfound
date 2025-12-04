FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    zip unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip pdo pdo_mysql gd

# Copy application
COPY . /var/www/html

# Set permissions
RUN chmod -R 777 storage bootstrap/cache

# Copy Nginx config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf.template /etc/nginx/conf.d/default.conf

# Copy Supervisor config
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]
