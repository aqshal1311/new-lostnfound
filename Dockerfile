# Gunakan PHP 8.3 FPM official image
FROM php:8.3-fpm

# Install libraries untuk GD, Zip, dll
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip

# Install GD extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install PDO MySQL & ZIP
RUN docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working dir
WORKDIR /var/www/html

# Copy all project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions (penting untuk Laravel)
RUN chmod -R 777 storage bootstrap/cache

# Expose Laravel port
EXPOSE 8000

# Jalankan Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
