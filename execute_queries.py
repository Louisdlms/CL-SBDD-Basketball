import sqlite3

def execute_queries_from_file(db_path, sql_file_path):
    """Exécute les requêtes SQL depuis un fichier sur une base de données SQLite."""

    # Connexion à la base de données
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Lire le fichier SQL
    with open(sql_file_path, 'r', encoding='utf-8') as file:
        sql_script = file.read()

    # Diviser le script en requêtes individuelles
    queries = sql_script.split(';')

    # Exécuter chaque requête
    for i, query in enumerate(queries):
        query = query.strip()
        if query:  # Ignorer les lignes vides
            try:
                cursor.execute(query)
                results = cursor.fetchall()

                # Afficher les résultats
                if results:
                    print(f"\nRésultats de la requête {i+1}:")
                    column_names = [description[0] for description in cursor.description]
                    print("\t" + "\t|\t".join(column_names))
                    print("-" * (sum(len(col) for col in column_names) + 3 * len(column_names)))

                    for row in results:
                        print("\t" + "\t|\t".join(str(value) for value in row))
                else:
                    print(f"\nRequête {i+1} exécutée, aucun résultat.")

            except sqlite3.Error as e:
                print(f"\nErreur lors de l'exécution de la requête {i+1}: {e}")

    # Fermer la connexion
    conn.close()

if __name__ == "__main__":
    db_path = "basketball.db"
    sql_file_path = "SQL Scripts/queries.sql"
    execute_queries_from_file(db_path, sql_file_path)
