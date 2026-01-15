FROM php:8.1-apache

# Apache basic config
RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# PHP extensions required by SIMRS Khanza
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install mysqli pdo pdo_mysql gd zip \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy exactly like XAMPP htdocs
COPY webapps/ /var/www/html/webapps/

# Point Apache to the real entry point
RUN sed -i 's|/var/www/html|/var/www/html/webapps|g' \
    /etc/apache2/sites-available/000-default.conf

# Entrypoint for ENV → database.ini
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Permissions (important for Khanza)
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 777 /var/www/html/webapps/tmp || true \
 && chmod -R 777 /var/www/html/webapps/backup || true

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
