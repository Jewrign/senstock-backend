# Image officielle PHP avec Apache
FROM php:8.2-apache

# Installer les extensions nécessaires (dont pdo_pgsql)
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Vérification : PDO_PGSQL doit être actif
RUN php -m | grep -i pdo_pgsql || (echo "❌ ERREUR : pdo_pgsql non installé !" && exit 1)

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers du projet Laravel
COPY . .

# Donner les bonnes permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copier .env.example si .env absent (sécurité Render)
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Nettoyer et regénérer les caches Laravel
RUN php artisan config:clear \
 && php artisan route:clear \
 && php artisan view:clear \
 && php artisan config:cache

# Lancer automatiquement les migrations (évite 500 erreur de tables manquantes)
RUN php artisan migrate --force || true

# Activer le module mod_rewrite pour Laravel
RUN a2enmod rewrite

# Remplacer la config Apache par la tienne
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir /public comme racine du serveur
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
