import sqlite3

# Connexion à la base
conn = sqlite3.connect("basketball.db")
cursor = conn.cursor()

# Liste des titres pour chaque requête (dans le même ordre que queries.sql)
titles = [
    "Top 10 joueurs par points totaux en équipe nationale",
    "Top 3 FT% dans la finale du European Championship 2022",
    "Club avec la plus grande taille moyenne",
    "Sponsor le plus lié à des équipes championnes du monde",
    "Meilleurs shooteurs à 3 pts par club (saison 2023-2024)"
]

# Lire toutes les requêtes depuis queries.sql
with open("SQL Scripts/queries.sql", "r", encoding="utf-8") as f:
    sql_script = f.read()

# SQLite ne peut pas exécuter tout le script d'un coup avec fetchall
# On sépare les requêtes par ';' et on exécute individuellement
queries = [q.strip() for q in sql_script.split(';') if q.strip()]

for title, q in zip(titles, queries):
    print(f"\n=== {title} ===")
    try:
        cursor.execute(q)
        rows = cursor.fetchall()
        if rows:
            headers = [desc[0] for desc in cursor.description]
            print(headers)
            for row in rows:
                print(row)
        else:
            print("Aucun résultat trouvé.")
    except Exception as e:
        print(f"Erreur : {e}")

conn.close()
print("\nToutes les requêtes ont été exécutées.")
