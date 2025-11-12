import sqlite3
import os

# Chemin des fichiers SQL (adapte selon ton organisation)
SCRIPT_CREATE_TABLES = "SQL Scripts/basketball.sql"  # Contient le script de création des tables
SCRIPT_INSERT_DATA = "SQL Scripts/insert_data.sql"   # Contient le script d'insertion des données

# Liste des tables de ta base (selon le schéma fourni)
tables = [
    "Sponsor",
    "Club",
    "National_Team",
    "Player",
    "Competition",
    "Game",
    "Plays_for_Club",
    "Plays_in",
    "Club_Plays_in",
    "NT_Plays_in",
    "Sponsors_Club",
    "Sponsors_NT"
]

# Connexion à la base de données
conn = sqlite3.connect("basketball.db")
cursor = conn.cursor()

# Suppression des tables existantes
print("Suppression des tables existantes...")
for table in tables:
    try:
        cursor.execute(f"DROP TABLE IF EXISTS {table};")
    except sqlite3.Error as e:
        print(f"Erreur lors de la suppression de la table {table}: {e}")
conn.commit()

# Création des tables
print("Création des tables...")
try:
    with open(SCRIPT_CREATE_TABLES, "r", encoding="utf-8") as f:
        cursor.executescript(f.read())
    conn.commit()
    print("Tables créées avec succès !")
except FileNotFoundError:
    print(f"Erreur: Le fichier {SCRIPT_CREATE_TABLES} est introuvable.")
except sqlite3.Error as e:
    print(f"Erreur lors de la création des tables: {e}")

# Insertion des données
print("Insertion des données...")
try:
    with open(SCRIPT_INSERT_DATA, "r", encoding="utf-8") as f:
        cursor.executescript(f.read())
    conn.commit()
    print("Données insérées avec succès !")
except FileNotFoundError:
    print(f"Erreur: Le fichier {SCRIPT_INSERT_DATA} est introuvable.")
except sqlite3.Error as e:
    print(f"Erreur lors de l'insertion des données: {e}")

# Fermeture de la connexion
conn.close()
print("Base de données 'basketball.db' prête à l'emploi !")
