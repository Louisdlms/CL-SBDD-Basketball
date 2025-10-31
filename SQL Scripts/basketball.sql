PRAGMA foreign_keys = ON;

-- Table: League
CREATE TABLE League (
    id_league INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    foundation_year INTEGER
);

-- Table: Club
CREATE TABLE Club (
    id_club INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT,
    id_league INTEGER,
    FOREIGN KEY (id_league) REFERENCES League(id_league)
);

-- Table: National_Team
CREATE TABLE National_Team (
    id_team INTEGER PRIMARY KEY,
    country TEXT NOT NULL
);

-- Table: Sponsor
CREATE TABLE Sponsor (
    id_sponsor INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    amount REAL,
    id_beneficiary_club INTEGER,
    id_beneficiary_team INTEGER,
    FOREIGN KEY (id_beneficiary_club) REFERENCES Club(id_club)
    FOREIGN KEY (id_beneficiary_team) REFERENCES National_Team(id_team)
);

-- Table: Player
CREATE TABLE Player (
    player_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    birth_date TEXT,
    height REAL,
    citizenship TEXT,
    id_club INTEGER,
    id_team INTEGER,
    FOREIGN KEY (id_club) REFERENCES Club(id_club),
    FOREIGN KEY (id_team) REFERENCES National_Team(id_team)
);

-- Table: Championship
CREATE TABLE Championship (
    id_championship INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year INTEGER,
    id_winner INTEGER,
    FOREIGN KEY (id_winner) REFERENCES National_Team(id_team)
);

-- Table: Competition
CREATE TABLE Competition (
    id_competition INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    season TEXT,
    id_winner INTEGER,
    id_league INTEGER,
    FOREIGN KEY (id_winner) REFERENCES Club(id_club),
    FOREIGN KEY (id_league) REFERENCES League(id_league)
);

-- Table: Game
CREATE TABLE Game (
    id_game INTEGER PRIMARY KEY,
    id_club1 INTEGER,
    id_club2 INTEGER,
    id_team1 INTEGER,
    id_team2 INTEGER,
    date TEXT,
    game_type TEXT CHECK (game_type IN ('club', 'national')),
    id_competition INTEGER,
    id_championship INTEGER,
    FOREIGN KEY (id_club1) REFERENCES Club(id_club),
    FOREIGN KEY (id_club2) REFERENCES Club(id_club),
    FOREIGN KEY (id_team1) REFERENCES National_Team(id_team),
    FOREIGN KEY (id_team2) REFERENCES National_Team(id_team),
    FOREIGN KEY (id_competition) REFERENCES Competition(id_competition),
    FOREIGN KEY (id_championship) REFERENCES Championship(id_championship)
);

-- Table: Player_Game_Stats
CREATE TABLE Player_Game_Stats (
    id_stats INTEGER PRIMARY KEY,
    id_game INTEGER,
    id_player INTEGER,
    "3_pts_md" INTEGER,
    "2_pts_md" INTEGER,
    ft_md INTEGER,
    "3_pts_perc" REAL,
    "2_pts_perc" REAL,
    ft_perc REAL,
    assists INTEGER,
    rebounds INTEGER,
    blocks INTEGER,
    fouls INTEGER,
    FOREIGN KEY (id_game) REFERENCES Game(id_game),
    FOREIGN KEY (id_player) REFERENCES Player(player_id)
);
