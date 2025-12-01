# Base image PHP + FPM + Nginx yang stabil untuk Laravel
FROM serversideup/php:8.3-fpm-nginx

# Install GD extension (untuk simple-qrcode)
RUN install-php-extensions gd

# Working directory
WORKDIR /var/www/html

# Copy file project
COPY . .

# Install composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Optimize Laravel (optional)
RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

# Port default Nginx
EXPOSE 8080

# Jalankan supervisord (nginx + php-fpm)
CMD ["/usr/bin/supervisord"]
