FROM php:8.2-apache

# Installer extensions nécessaires (dont pdo_pgsql pour PostgreSQL)
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir répertoire de travail
WORKDIR /var/www/html

# Copier tout le projet Laravel
COPY . .

# Donner les permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Générer la clé de l'application si non présente
RUN if [ ! -f .env ]; then cp .env.example .env; fi \
    && php artisan key:generate \
    && php artisan config:cache \
    && php artisan migrate --force

# Activer mod_rewrite
RUN a2enmod rewrite

# Configurer Apache
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Spécifier le répertoire public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
