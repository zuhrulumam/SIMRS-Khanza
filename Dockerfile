FROM php:8.1-apache

RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install mysqli pdo pdo_mysql gd zip \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy webapps exactly like XAMPP htdocs
COPY webapps/ /var/www/html/

# Point Apache to khanza
RUN sed -i 's|/var/www/html|/var/www/html/khanza|g' \
    /etc/apache2/sites-available/000-default.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 777 /var/www/html/khanza/tmp || true \
 && chmod -R 777 /var/www/html/khanza/backup || true

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
