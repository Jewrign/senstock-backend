# Image de base PHP avec Apache
FROM php:8.2-apache

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Vérifier que pdo_pgsql est bien installé
RUN php -m | grep -i pdo_pgsql || (echo "❌ ERREUR : pdo_pgsql non installé" && exit 1)

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tout le projet Laravel
COPY . .

# Donner les bonnes permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copier le .env.example si .env n'existe pas (utile pour Render)
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader

# Supprimer les caches Laravel (PAS de config:cache)
RUN rm -rf bootstrap/cache/*.php \
    && php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Activer mod_rewrite
RUN a2enmod rewrite

# Copier le fichier Apache custom
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Définir le répertoire public comme racine du serveur
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Copier le script de démarrage
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Démarrer via le script personnalisé (migrations + apache)
CMD ["/entrypoint.sh"]
