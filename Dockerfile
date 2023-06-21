# Use the official PHP image as the base image
FROM php:8.1-apache

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock files to the container
COPY composer.json composer.lock ./

# Install PHP extensions and dependencies
RUN apt-get update && \
    apt-get install -y libonig-dev libxml2-dev && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the rest of the application files to the container
COPY . .

# Install application dependencies
RUN composer install --no-interaction --no-plugins --no-scripts

# Set the Apache document root to the public directory
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Enable Apache rewrite module
RUN a2enmod rewrite

# Expose port 80 for the Apache server
EXPOSE 80

# Start the Apache serve
CMD ["apache2-foreground"]
