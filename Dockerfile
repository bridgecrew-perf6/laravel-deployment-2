FROM php:8.0-fpm
# COPY ./laravel_run_up.sh /var/www/laravel_run_up.sh

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -m laravel
RUN mkdir -p /home/$user/.composer && \
    chown -R laravel:laravel /home/laravel

# Set working directory
WORKDIR /var/www
COPY php-fpm/laravel_run_up.sh /

USER laravel