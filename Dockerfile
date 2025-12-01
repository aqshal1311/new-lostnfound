FROM php:8.3-fpm

# Install dependencies
RUN apt-get install -y nginx-full
    git curl unzip \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev \
    nginx supervisor gettext-base \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Workdir
WORKDIR /var/www/html

# Copy project
COPY . .

# Composer install
RUN composer install --no-dev --optimize-autoloader

# Permission
RUN chmod -R 777 storage bootstrap/cache

COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy Nginx config
COPY ./nginx.conf.template /etc/nginx/conf.d/default.conf.template

COPY ./mime.types /etc/nginx/mime.types

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
