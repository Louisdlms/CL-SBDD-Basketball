-- ======================================================
-- SPONSORS
-- ======================================================
INSERT INTO Sponsor (ID_Spo, name, city) VALUES
(1, 'Nike', 'New York'),
(2, 'Adidas', 'Munich');

-- ======================================================
-- CLUBS
-- ======================================================
INSERT INTO Club (ID_Clu, name, city) VALUES
(1, 'Real Madrid', 'Madrid'),
(2, 'FC Barcelona', 'Barcelona');

-- ======================================================
-- NATIONAL TEAMS
-- ======================================================
INSERT INTO National_Team (ID_Nat, country) VALUES
(1, 'Spain'),
(2, 'France');

-- ======================================================
-- PLAYERS
-- ======================================================
INSERT INTO Player (ID_Pla, name, birth, height, citizenship, ID_Nat) VALUES
(1, 'Pau Gasol', '1980-07-06', 213, 'Spain', 1),
(2, 'Tony Parker', '1982-05-17', 188, 'France', 2),
(3, 'Sergio Llull', '1987-11-15', 190, 'Spain', 1),
(4, 'Ricky Rubio', '1990-10-21', 193, 'Spain', 1);

-- ======================================================
-- COMPETITIONS
-- ======================================================
INSERT INTO Competition (ID_Com, name, season, type) VALUES
(1, 'Euroleague', '2024-2025', 'Club'),
(2, 'EuroBasket', '2002', 'National'),
(3, 'World Championship', '2006', 'National'),
(4, 'Euroleague', '2023-2024', 'Club'),
(5, 'Euroleague', '2022-2023', 'Club'),
(6, 'Euroleague', '2021-2022', 'Club');

-- ======================================================
-- GAMES
-- ======================================================
INSERT INTO Game (ID_Gam, game_type, date, ID_Com) VALUES
(1, 'finale', '2002-09-15', 2),  -- EuroBasket 2002 finale
(2, 'saison régulière', '2024-10-01', 1), -- Euroleague 2024-2025
(3, 'finale', '2006-09-03', 3), -- World Championship finale
(4, 'finale', '2024-05-28', 1), -- Euroleague finale pour Real Madrid
(5, 'finale', '2023-05-29', 4),
(6, 'finale', '2022-05-30', 5),
(7, 'finale', '2021-05-31', 6),
(8, 'saison régulière', '2024-10-10', 1);

-- ======================================================
-- PLAYS_FOR_CLUB
-- ======================================================
INSERT INTO Plays_for_Club (ID_Pla, ID_Clu, start_date, end_date) VALUES
(1, 1, '2000-01-01', '2025-12-31'),
(2, 2, '2000-01-01', '2025-12-31'),
(3, 1, '2007-01-01', '2025-12-31'),
(4, 1, '2009-01-01', '2025-12-31');

-- ======================================================
-- PLAYS_IN (CLUB)
-- ======================================================
INSERT INTO Plays_in (ID_Gam, ID_Pla, pts_3_md, pts_2_md, ft_md, pts_3_perc, pts_2_perc, ft_perc, assists, rebounds, blocks, fouls) VALUES
-- Saison 2024-2025 pour Requête 5 et 6
(2, 1, 2, 4, 3, 0.45, 0.5, 0.85, 5, 7, 1, 2),
(2, 3, 3, 2, 2, 0.55, 0.5, 0.9, 4, 4, 0, 1),
(2, 4, 1, 3, 1, 0.4, 0.6, 0.8, 6, 5, 1, 2),
(8, 2, 2, 3, 1, 0.4, 0.5, 0.85, 7, 5, 0, 1);

-- ======================================================
-- PLAYS_IN (NATIONAL TEAM)
-- ======================================================
INSERT INTO Plays_in (ID_Gam, ID_Pla, pts_3_md, pts_2_md, ft_md, pts_3_perc, pts_2_perc, ft_perc, assists, rebounds, blocks, fouls) VALUES
-- EuroBasket 2002
(1, 1, 3, 4, 6, 0.5, 0.6, 0.9, 2, 8, 1, 3),
(1, 2, 2, 5, 5, 0.45, 0.65, 0.95, 3, 4, 0, 2),
-- World Championship 2006
(3, 1, 4, 5, 6, 0.5, 0.55, 0.9, 4, 6, 1, 2),
(3, 2, 3, 4, 5, 0.45, 0.5, 0.85, 2, 5, 0, 1);

-- ======================================================
-- CLUB_PLAYS_IN (win pour Euroleague)
-- ======================================================
INSERT INTO Club_Plays_in (ID_Clu, ID_Gam, win) VALUES
(1, 4, 'yes'),
(1, 5, 'yes'),
(1, 6, 'yes'),
(1, 7, 'yes'),-- 4 victoires pour Requête 7
(2, 8, 'no'); 
-- ======================================================
-- NT_PLAYS_IN (win pour World Championship)
-- ======================================================
INSERT INTO NT_Plays_in (ID_Nat, ID_Gam, win) VALUES
(1, 3, 'yes'), -- Spain a gagné World Championship
(2, 1, 'no');  -- France

-- ======================================================
-- SPONSORS_CLUB
-- ======================================================
INSERT INTO Sponsors_Club (ID_Clu, ID_Spo, amount, start_date, end_date) VALUES
(1, 1, 5000000, '2020-01-01', '2025-12-31');

-- ======================================================
-- SPONSORS_NT
-- ======================================================
INSERT INTO Sponsors_NT (ID_Nat, ID_Spo, amount, start_date, end_date) VALUES
(1, 1, 2000000, '2000-01-01', '2010-12-31');
