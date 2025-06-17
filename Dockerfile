# Image de base PHP avec Apache
FROM php:8.2-apache

# Installer les extensions nécessaires (incluant PostgreSQL)
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Vérification de l'installation de pdo_pgsql
RUN php -m | grep -i pdo_pgsql || (echo "❌ pdo_pgsql non installé !" && exit 1)

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier les fichiers du projet Laravel
COPY . .

# Permissions correctes
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copier .env.example s'il n'y a pas encore de .env
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Supprimer tous les caches Laravel (PAS de config:cache ici)
RUN rm -rf bootstrap/cache/*.php \
    && php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Lancer automatiquement les migrations à chaque build (ignorer erreur si déjà migré)
RUN php artisan migrate --force || true

# Activer mod_rewrite pour Laravel
RUN a2enmod rewrite

# Utiliser notre config Apache
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir le dossier public comme racine du serveur
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
