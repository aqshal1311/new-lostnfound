# =========================
# Stage 1: PHP-FPM + Laravel
# =========================
FROM php:8.3-fpm AS php_stage

RUN apt-get update && apt-get install -y \
    git curl unzip \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 storage bootstrap/cache


# =========================
# Stage 2: Nginx + PHP-FPM RUNNING
# =========================
FROM nginx:alpine

# Copy project ke container
COPY --from=php_stage /var/www/html /var/www/html
WORKDIR /var/www/html

# Copy Nginx config
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Copy PHP-FPM binary dari Stage 1
COPY --from=php_stage /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
COPY --from=php_stage /usr/local/etc/php-fpm.d /usr/local/etc/php-fpm.d
COPY --from=php_stage /usr/local/lib/php /usr/local/lib/php

# Expose port 80
EXPOSE 80

# Jalankan BOTH php-fpm dan nginx
CMD php-fpm -D && nginx -g "daemon off;"
