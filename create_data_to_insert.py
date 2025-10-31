import random
from datetime import datetime, timedelta

# Paramètres
num_players = 120
num_clubs = 30
num_teams = 10
num_sponsors = 15
num_championships = 10
num_competitions = 10
num_games_club = 80
num_games_national = 40
games_per_player = 20  # chaque joueur joue ~20 matchs aléatoires

# Noms fictifs
first_names = ["John", "Mike", "Chris", "David", "James", "Robert", "Alex", "Mark", "Luke", "Tom"]
last_names = ["Smith", "Johnson", "Brown", "Williams", "Jones", "Miller", "Davis", "Garcia", "Martinez", "Wilson"]
club_names = [f"Club {i}" for i in range(1, num_clubs+1)]
team_countries = [f"Country {i}" for i in range(1, num_teams+1)]
sponsor_names = ["Nike", "Adidas", "Jordan", "Under Armour", "Puma", "Reebok", "Spalding", "Decathlon", "Peak", "Molten"]

# Fichier SQL de sortie
with open("SQL Scripts/insert_data.sql", "w") as f:

    # Joueurs
    f.write("-- Joueurs\n")
    for pid in range(1, num_players+1):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        birth = datetime(1980,1,1) + timedelta(days=random.randint(0,15000))
        height = round(random.uniform(1.75, 2.20),2)
        citizenship = random.choice(team_countries)
        club = random.randint(1,num_clubs)
        team = random.randint(1,num_teams)
        f.write(f"INSERT INTO Player (player_id, name, birth_date, height, citizenship, id_club, id_team) "
                f"VALUES ({pid}, '{name}', '{birth.date()}', {height}, '{citizenship}', {club}, {team});\n")

    # Leagues
    f.write("\n-- Leagues\n")
    for lid in range(1, 4):  # 3 ligues fictives
        name = f"League {lid}"
        year = random.randint(1900, 2020)
        f.write(f"INSERT INTO League (id_league, name, foundation_year) VALUES ({lid}, '{name}', {year});\n")

    # Clubs
    f.write("\n-- Clubs\n")
    for cid, cname in enumerate(club_names, 1):
        city = f"City {cid}"
        league = random.randint(1,3)
        f.write(f"INSERT INTO Club (id_club, name, city, id_league) VALUES ({cid}, '{cname}', '{city}', {league});\n")

    # National Teams
    f.write("\n-- National Teams\n")
    for tid, country in enumerate(team_countries, 1):
        f.write(f"INSERT INTO National_Team (id_team, country) VALUES ({tid}, '{country}');\n")

    # Sponsors
    f.write("\n-- Sponsors\n")
    for sid in range(1, num_sponsors+1):
        name = random.choice(sponsor_names)
        amount = random.randint(500000,5000000)
        club_id = random.randint(1,num_clubs)
        team_id = random.randint(1,num_teams)
        f.write(f"INSERT INTO Sponsor (id_sponsor, name, amount, id_beneficiary_club, id_beneficiary_team) "
                f"VALUES ({sid}, '{name}', {amount}, {club_id}, {team_id});\n")

    # Championships
    f.write("\n-- Championships\n")
    for cid in range(1, num_championships+1):
        name = f"Championship {cid}"
        year = 2000 + cid
        winner = random.randint(1,num_teams)
        f.write(f"INSERT INTO Championship (id_championship, name, year, id_winner) "
                f"VALUES ({cid}, '{name}', {year}, {winner});\n")

    # Competitions
    f.write("\n-- Competitions\n")
    for cid in range(1, num_competitions+1):
        name = f"Competition {cid}"
        season = f"{2020+cid}-{2021+cid}"
        winner = random.randint(1,num_clubs)
        league = random.randint(1,3)
        f.write(f"INSERT INTO Competition (id_competition, name, season, id_winner, id_league) "
                f"VALUES ({cid}, '{name}', '{season}', {winner}, {league});\n")

    # Games club
    f.write("\n-- Club Games\n")
    for gid in range(1, num_games_club+1):
        c1 = random.randint(1,num_clubs)
        c2 = random.randint(1,num_clubs)
        while c2 == c1:
            c2 = random.randint(1,num_clubs)
        date = datetime(2023,1,1) + timedelta(days=random.randint(0,365))
        comp = random.randint(1,num_competitions)
        f.write(f"INSERT INTO Game (id_game, id_club1, id_club2, id_team1, id_team2, date, game_type, id_competition, id_championship) "
                f"VALUES ({gid}, {c1}, {c2}, NULL, NULL, '{date.date()}', 'club', {comp}, NULL);\n")

    # Games national
    f.write("\n-- National Games\n")
    for gid in range(num_games_club+1, num_games_club+num_games_national+1):
        t1 = random.randint(1,num_teams)
        t2 = random.randint(1,num_teams)
        while t2 == t1:
            t2 = random.randint(1,num_teams)
        date = datetime(2023,1,1) + timedelta(days=random.randint(0,365))
        champ = random.randint(1,num_championships)
        f.write(f"INSERT INTO Game (id_game, id_club1, id_club2, id_team1, id_team2, date, game_type, id_competition, id_championship) "
                f"VALUES ({gid}, NULL, NULL, {t1}, {t2}, '{date.date()}', 'national', NULL, {champ});\n")

    # Player Game Stats (chaque joueur joue ~games_per_player matchs aléatoires)
    f.write("\n-- Player Game Stats\n")
    stat_id = 1
    for pid in range(1,num_players+1):
        games = random.sample(range(1,num_games_club+num_games_national+1), games_per_player)
        for gid in games:
            pts3 = random.randint(0,8)
            pts2 = random.randint(0,12)
            ft = random.randint(0,10)

            # Éviter division par zéro
            pct3 = round(pts3 / max(1, pts3 + random.randint(0,3)), 2)
            pct2 = round(pts2 / max(1, pts2 + random.randint(0,3)), 2)
            ft_pct = round(ft / max(1, ft + random.randint(0,2)), 2)

            assists = random.randint(0,10)
            rebounds = random.randint(0,12)
            blocks = random.randint(0,5)
            fouls = random.randint(0,5)

            f.write(f"INSERT INTO Player_Game_Stats (id_stats, id_game, id_player, \"3_pts_md\", \"2_pts_md\", ft_md, "
                    f"\"3_pts_perc\", \"2_pts_perc\", ft_perc, assists, rebounds, blocks, fouls) "
                    f"VALUES ({stat_id}, {gid}, {pid}, {pts3}, {pts2}, {ft}, {pct3}, {pct2}, {ft_pct}, {assists}, {rebounds}, {blocks}, {fouls});\n")
            stat_id += 1

print("Script SQL généré : SQL Scripts/insert_data.sql")
