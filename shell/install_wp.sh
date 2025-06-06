#!/bin/bash

wp --version
wp core download --locale="fr_FR"

# Boucle wp-config + test connexion MySQL
success=false
until $success; do
  read -p "Entrez l'hôte de la base de données (ex: localhost) : " dbhost
  read -p "Entrez le nom de la base de données : " dbname
  read -p "Entrez le nom d'utilisateur de la base de données : " dbuser
  read -sp "Entrez le mot de passe de la base de données : " dbpass
  echo

  echo "⏳ Test de connexion MySQL..."
  if mysql -h "$dbhost" -u "$dbuser" -p"$dbpass" "$dbname" -e "quit" 2>/dev/null; then
    echo "✅ Connexion MySQL réussie."
    myprefix="wp$(tr -dc '0-9' < /dev/urandom | head -c 4)_"
    wp config create --dbhost="$dbhost" --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --locale="fr_FR" --dbprefix="$myprefix"
    success=true
  else
    echo "❌ Connexion MySQL échouée. Vérifie les infos et réessaie."
  fi
done

# Infos site
read -p "Entrez l'URL du site (ex: https://example.com) : " site_url
read -p "Entrez le titre du site : " site_title
read -p "Entrez le nom d'utilisateur admin : " admin_user
read -sp "Entrez le mot de passe admin : " admin_password
echo
read -p "Entrez l'email de l'admin : " admin_email

# wp install
wp core install --url="$site_url" --title="$site_title" --admin_user="$admin_user" --admin_password="$admin_password" --admin_email="$admin_email"

history -c
