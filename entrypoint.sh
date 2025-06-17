#!/bin/bash

echo "⏳ Attente de la base PostgreSQL..."

# Essayer de lancer les migrations tant que la DB n'est pas prête
until php artisan migrate --force; do
  echo "🔁 Nouvelle tentative de migration dans 5 secondes..."
  sleep 5
done

# Créer le lien symbolique vers /storage (public)
echo "🔗 Création du lien vers public/storage..."
php artisan storage:link

# Démarrer Apache
echo "🚀 Lancement du serveur Apache..."
apache2-foreground
