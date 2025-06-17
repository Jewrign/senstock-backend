#!/bin/bash

# Attendre que PostgreSQL soit prêt
echo "⏳ Attente de la base de données..."
until php artisan migrate --force; do
  echo "🔁 Nouvelle tentative dans 5s..."
  sleep 5
done

# Lancer Apache (ce que Render attend)
echo "✅ Migrations terminées. Démarrage du serveur Apache..."
apache2-foreground
