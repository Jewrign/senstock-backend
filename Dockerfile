FROM php:8.2-apache

# Installer les extensions nécessaires
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tout le projet Laravel
COPY . .

# Donner les permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Nettoyer et regénérer les caches Laravel
RUN php artisan config:clear \
 && php artisan route:clear \
 && php artisan view:clear \
 && php artisan config:cache

# Lancer les migrations (automatique au build)
RUN php artisan migrate --force || true

# Activer mod_rewrite
RUN a2enmod rewrite

# Configurer Apache pour pointer vers /public
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire public comme racine
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
