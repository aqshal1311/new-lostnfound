# Gunakan PHP 8.3
FROM php:8.3-fpm

# Install dependencies sistem
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Ganti permission (untuk storage & cache)
RUN chmod -R 777 storage bootstrap/cache

# Expose port
EXPOSE 8000

# Start Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
