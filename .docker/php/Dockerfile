FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . /var/www/html

# Ensure correct permissions for storage and bootstrap/cache directories, excluding .gitignore files
RUN find /var/www/html/storage /var/www/html/bootstrap/cache -type f ! -name '.gitignore' -exec chown www-data:www-data {} \; \
    && find /var/www/html/storage /var/www/html/bootstrap/cache -type f ! -name '.gitignore' -exec chmod 775 {} \; \
    && find /var/www/html/storage /var/www/html/bootstrap/cache -type d -exec chown www-data:www-data {} \; \
    && find /var/www/html/storage /var/www/html/bootstrap/cache -type d -exec chmod 775 {} \;

# Run Composer install
RUN composer install --no-dev --prefer-dist --optimize-autoloader

CMD ["php-fpm"]
