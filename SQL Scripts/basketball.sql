PRAGMA foreign_keys = ON;

-- Table: Sponsor
CREATE TABLE Sponsor (
    ID_Spo INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT
);

-- Table: Club
CREATE TABLE Club (
    ID_Clu INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT
);

-- Table: National_Team
CREATE TABLE National_Team (
    ID_Nat INTEGER PRIMARY KEY,
    country TEXT NOT NULL
);

-- Table: Player
CREATE TABLE Player (
    ID_Pla INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    birth DATE,
    height INTEGER,
    citizenship TEXT,
    ID_Nat INTEGER,
    FOREIGN KEY (ID_Nat) REFERENCES National_Team(ID_Nat)
);

-- Table: Competition
CREATE TABLE Competition (
    ID_Com INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    season TEXT,
    type TEXT CHECK (type IN ('National', 'Club'))
);

-- Table: Game
CREATE TABLE Game (
    ID_Gam INTEGER PRIMARY KEY,
    game_type TEXT,
    date DATE,
    ID_Com INTEGER,
    FOREIGN KEY (ID_Com) REFERENCES Competition(ID_Com),
    CHECK (game_type IN ('saison régulière', '1/16 finale', '1/8 finale', '1/4 finale', '1/2 finale', 'finale'))
);

-- Table: Plays_for_Club
CREATE TABLE Plays_for_Club (
    ID_Pla INTEGER,
    ID_Clu INTEGER,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (ID_Pla, ID_Clu),
    FOREIGN KEY (ID_Pla) REFERENCES Player(ID_Pla),
    FOREIGN KEY (ID_Clu) REFERENCES Club(ID_Clu)
);

-- Table: Plays_in
CREATE TABLE Plays_in (
    ID_Gam INTEGER,
    ID_Pla INTEGER,
    pts_3_md INTEGER,
    pts_2_md INTEGER,
    ft_md INTEGER,
    pts_3_perc REAL,
    pts_2_perc REAL,
    ft_perc REAL,
    assists INTEGER,
    rebounds INTEGER,
    blocks INTEGER,
    fouls INTEGER,
    PRIMARY KEY (ID_Gam, ID_Pla),
    FOREIGN KEY (ID_Gam) REFERENCES Game(ID_Gam),
    FOREIGN KEY (ID_Pla) REFERENCES Player(ID_Pla)
);

-- Table: Club_Plays_in
CREATE TABLE Club_Plays_in (
    ID_Clu INTEGER,
    ID_Gam INTEGER,
    win TEXT CHECK (win IN ('yes', 'no')),
    PRIMARY KEY (ID_Clu, ID_Gam),
    FOREIGN KEY (ID_Clu) REFERENCES Club(ID_Clu),
    FOREIGN KEY (ID_Gam) REFERENCES Game(ID_Gam)
);

-- Table: NT_Plays_in
CREATE TABLE NT_Plays_in (
    ID_Nat INTEGER,
    ID_Gam INTEGER,
    win TEXT CHECK (win IN ('yes', 'no')),
    PRIMARY KEY (ID_Nat, ID_Gam),
    FOREIGN KEY (ID_Nat) REFERENCES National_Team(ID_Nat),
    FOREIGN KEY (ID_Gam) REFERENCES Game(ID_Gam)
);

-- Table: Sponsors_Club
CREATE TABLE Sponsors_Club (
    ID_Clu INTEGER,
    ID_Spo INTEGER,
    amount REAL,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (ID_Clu, ID_Spo),
    FOREIGN KEY (ID_Clu) REFERENCES Club(ID_Clu),
    FOREIGN KEY (ID_Spo) REFERENCES Sponsor(ID_Spo)
);

-- Table: Sponsors_NT
CREATE TABLE Sponsors_NT (
    ID_Nat INTEGER,
    ID_Spo INTEGER,
    amount REAL,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (ID_Nat, ID_Spo),
    FOREIGN KEY (ID_Nat) REFERENCES National_Team(ID_Nat),
    FOREIGN KEY (ID_Spo) REFERENCES Sponsor(ID_Spo)
);
