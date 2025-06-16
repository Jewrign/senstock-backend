FROM php:8.2-apache-bullseye

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql opcache \
    && docker-php-ext-enable pdo_pgsql pdo_mysql opcache

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers Laravel
COPY . .

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Installer dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Activer mod_rewrite Apache
RUN a2enmod rewrite

# Configurer Apache
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire public comme racine
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
