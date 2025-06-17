# Utilise l'image officielle PHP avec Apache
FROM php:8.2-apache

# Installer les extensions nécessaires
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Vérifie que l'extension pdo_pgsql est bien installée
RUN php -m | grep -i pdo_pgsql || (echo "❌ pdo_pgsql non installé !" && exit 1)

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tout le projet Laravel
COPY . .

# Donner les bonnes permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copier le .env.example si aucun .env n'existe (utile sur Render)
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Nettoyage des caches Laravel (pas de config:cache ici)
RUN rm -rf bootstrap/cache/*.php \
    && php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Exécution forcée des migrations PostgreSQL
RUN php artisan migrate --force || true

# Activer mod_rewrite pour Laravel
RUN a2enmod rewrite

# Utiliser la configuration Apache personnalisée
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire public comme racine du serveur
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
