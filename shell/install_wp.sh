#!/bin/bash

wp --version
wp core download --locale="fr_FR"


# Demande des informations sur la base de données
read -p "Entrez l'hôte de la base de données (ex: localhost) : " dbhost
read -p "Entrez le nom de la base de données : " dbname
read -p "Entrez le nom d'utilisateur de la base de données : " dbuser
read -sp "Entrez le mot de passe de la base de données : " dbpass
echo # nouvelle ligne après la saisie du mot de passe
read -p "Entrez la locale (ex: fr_FR) : " locale

# Création du fichier wp-config
if wp config create --dbhost="$dbhost" --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --locale="$locale"; then
    echo "Fichier wp-config créé avec succès."
else
    echo "Erreur lors de la création du fichier wp-config."
    exit 1
fi

# Demande des informations à l'utilisateur
read -p "Entrez l'URL du site (ex: https://example.com) : " site_url
read -p "Entrez le titre du site : " site_title
read -p "Entrez le nom d'utilisateur admin : " admin_user
read -sp "Entrez le mot de passe admin : " admin_password
echo # nouvelle ligne après la saisie du mot de passe
read -p "Entrez l'email de l'admin : " admin_email

# wp install
wp core install --url="$site_url" --title="$site_title" --admin_user="$admin_user" --admin_password="$admin_password" --admin_email="$admin_email"

rm wp-config-sample.php
history -c