import random
import datetime

# ==========================
# CONFIGURATION
# ==========================

def generate_insert_script(db_size="small"):
    """
    db_size ∈ {"small", "medium", "large"}
    """

    # Réglages de taille
    sizes = {
        "small": {"clubs": 6, "players": 20, "games": 10},
        "medium": {"clubs": 12, "players": 40, "games": 25},
        "large": {"clubs": 30, "players": 120, "games": 300}
    }
    cfg = sizes[db_size]

    random.seed(42)

    sql = "-- =============================================\n"
    sql += f"-- SCRIPT DE DONNÉES GÉNÉRÉ AUTOMATIQUEMENT ({db_size.upper()})\n"
    sql += "-- =============================================\n\n"

    # ==========================
    # 1. SPONSORS
    # ==========================
    sponsor_names = ["Nike", "Adidas", "Puma", "Under Armour", "Jordan Brand", "New Balance", "Reebok", "Converse"]
    sponsor_rows = [(i + 1, sponsor_names[i % len(sponsor_names)], f"City_{i+1}") for i in range(len(sponsor_names))]
    sql += make_insert("Sponsor", ["ID_Spo", "name", "city"], sponsor_rows)

    # ==========================
    # 2. CLUBS
    # ==========================
    club_rows = [(i + 1, f"Club_{i+1}", f"City_{i+1}") for i in range(cfg["clubs"])]
    sql += make_insert("Club", ["ID_Clu", "name", "city"], club_rows)

    # ==========================
    # 3. NATIONAL TEAMS
    # ==========================
    countries = ["USA", "France", "Spain", "Serbia", "Greece", "Lithuania", "Germany", "Italy", "Argentina", "Australia"]
    nt_rows = [(i + 1, countries[i % len(countries)]) for i in range(len(countries))]
    sql += make_insert("National_Team", ["ID_Nat", "country"], nt_rows)

    # ==========================
    # 4. COMPETITIONS
    # ==========================
    comp_types = [("Euroleague", "Club"), ("World Championship", "National"), ("European Championship", "National")]
    comp_rows = [(i + 1, c[0], f"{2020+i}-{2021+i}", c[1]) for i, c in enumerate(comp_types)]
    sql += make_insert("Competition", ["ID_Com", "name", "season", "type"], comp_rows)

    # ==========================
    # 5. GAMES
    # ==========================
    game_types = ['saison régulière', '1/4 finale', '1/2 finale', 'finale']
    games = []
    for i in range(cfg["games"]):
        games.append((i + 1, random.choice(game_types), rand_date(2020, 2025), random.randint(1, len(comp_rows))))
    sql += make_insert("Game", ["ID_Gam", "game_type", "date", "ID_Com"], games)

    # ==========================
    # 6. PLAYERS
    # ==========================
    players = []
    for i in range(cfg["players"]):
        name = f"Player_{i+1}"
        height = random.randint(175, 220)
        birth_year = random.randint(1980, 2004)
        birth = f"{birth_year}-{random.randint(1,12):02d}-{random.randint(1,28):02d}"
        citizenship = random.choice(countries)
        id_nat = countries.index(citizenship) + 1
        players.append((i + 1, name, birth, height, citizenship, id_nat))
    sql += make_insert("Player", ["ID_Pla", "name", "birth", "height", "citizenship", "ID_Nat"], players)

    # ==========================
    # 7. CLUB PARTICIPATION
    # ==========================
    club_plays = []
    for g in range(1, cfg["games"] + 1):
        clubs_in_game = random.sample(range(1, cfg["clubs"] + 1), 2)
        club_plays.extend([(c, g) for c in clubs_in_game])
    sql += make_insert("Club_Plays_in", ["ID_Clu", "ID_Gam"], club_plays)

    # ==========================
    # 8. NATIONAL TEAMS PARTICIPATION
    # ==========================
    nt_plays = []
    for g in range(1, cfg["games"] + 1):
        if random.random() < 0.3:  # environ 30% de matchs nationaux
            teams = random.sample(range(1, len(nt_rows) + 1), 2)
            nt_plays.extend([(t, g) for t in teams])
    sql += make_insert("NT_Plays_in", ["ID_Nat", "ID_Gam"], nt_plays)

    # ==========================
    # 9. PLAYS_IN (STATS)
    # ==========================
    stats_rows = []
    for g in range(1, cfg["games"] + 1):
        for p in random.sample(range(1, cfg["players"] + 1), 5):
            pts3 = random.randint(0, 6)
            pts2 = random.randint(0, 10)
            ft = random.randint(0, 8)
            perc3 = round(random.uniform(0.2, 0.6), 2)
            perc2 = round(random.uniform(0.4, 0.8), 2)
            ft_perc = round(random.uniform(0.6, 0.95), 2)
            assists = random.randint(0, 10)
            rebounds = random.randint(0, 12)
            blocks = random.randint(0, 3)
            fouls = random.randint(0, 4)
            stats_rows.append((g, p, pts3, pts2, ft, perc3, perc2, ft_perc, assists, rebounds, blocks, fouls))
    sql += make_insert("Plays_in",
                       ["ID_Gam", "ID_Pla", "pts_3_md", "pts_2_md", "ft_md", "pts_3_perc",
                        "pts_2_perc", "ft_perc", "assists", "rebounds", "blocks", "fouls"],
                       stats_rows)

    # ==========================
    # 10. SPONSORS - CLUBS
    # ==========================
    sponsors_clubs = []
    for c in range(1, cfg["clubs"] + 1):
        spo = random.randint(1, len(sponsor_rows))
        amount = random.randint(1000000, 5000000)
        sponsors_clubs.append((c, spo, amount, rand_date(2019, 2021), "2025-12-31"))
    sql += make_insert("Sponsors_Club", ["ID_Clu", "ID_Spo", "amount", "start_date", "end_date"], sponsors_clubs)

    # ==========================
    # 11. SPONSORS - NATIONAL TEAMS
    # ==========================
    sponsors_nt = []
    for n in range(1, len(nt_rows) + 1):
        spo = random.randint(1, len(sponsor_rows))
        amount = random.randint(2000000, 8000000)
        sponsors_nt.append((n, spo, amount, rand_date(2018, 2020), "2025-12-31"))
    sql += make_insert("Sponsors_NT", ["ID_Nat", "ID_Spo", "amount", "start_date", "end_date"], sponsors_nt)

    return sql


# ==========================
# UTILITAIRES
# ==========================

def rand_date(start_year, end_year):
    y = random.randint(start_year, end_year)
    m = random.randint(1, 12)
    d = random.randint(1, 28)
    return f"{y:04d}-{m:02d}-{d:02d}"

def make_insert(table, cols, rows):
    sql = f"-- {table}\nINSERT INTO {table} ({', '.join(cols)}) VALUES\n"
    val_lines = []
    for r in rows:
        vals = ", ".join(f"'{x}'" if isinstance(x, str) else str(x) for x in r)
        val_lines.append(f"({vals})")
    return sql + ",\n".join(val_lines) + ";\n\n"


# ==========================
# MAIN
# ==========================
if __name__ == "__main__":
    db_size = input("Choisir la taille de la base (small / medium / large) : ").strip().lower()
    sql = generate_insert_script(db_size if db_size in ["small", "medium", "large"] else "small")

    with open("insert_data.sql", "w", encoding="utf-8") as f:
        f.write(sql)

    print(f"✅ Script SQL généré avec succès : insert_data.sql ({db_size})")
