import sqlite3

conn = sqlite3.connect("basketball.db")
cursor = conn.cursor()

# Liste des tables de ta base
tables = [
    "Player_Game_Stats",
    "Game",
    "Competition",
    "Championship",
    "Player",
    "Sponsor",
    "National_Team",
    "Club",
    "League"
]

# Supprime toutes les tables
for table in tables:
    cursor.execute(f"DROP TABLE IF EXISTS {table};")

conn.commit()
conn.close()
print("Toutes les tables supprimées !")



conn = sqlite3.connect("basketball.db")
cursor = conn.cursor()

with open("SQL Scripts/basketball.sql", "r") as f:
    cursor.executescript(f.read())

conn.commit()
conn.close()
print("Base de données basketball.db créée avec succès !")





conn = sqlite3.connect("basketball.db")
cursor = conn.cursor()

data_script = open("SQL Scripts/insert_data.sql", "r", encoding="utf-8").read()
cursor.executescript(data_script)
conn.commit()
conn.close()
print("Données fictives insérées avec succès dans la base !")
