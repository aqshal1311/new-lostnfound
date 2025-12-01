# Base image dengan PHP-FPM + Nginx (server resmi untuk Laravel)
FROM serversideup/php:8.3-fpm-nginx

# Working directory
WORKDIR /var/www/html

# Copy file project
COPY . .

# Install composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Optimize Laravel
RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

# Expose port default Nginx (Railway akan automap)
EXPOSE 8080

# Jalankan nginx + php-fpm
CMD ["/usr/bin/supervisord"]
