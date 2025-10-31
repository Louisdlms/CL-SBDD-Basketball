-- 1) Top 10 joueurs par points totaux en équipe nationale
SELECT p.name,
       p.citizenship AS country,
       SUM((s."3_pts_md" * 3) + (s."2_pts_md" * 2) + s.ft_md) AS total_points
FROM Player p
JOIN Player_Game_Stats s ON p.player_id = s.id_player
JOIN Game g ON s.id_game = g.id_game
JOIN National_Team t ON p.id_team = t.id_team
WHERE g.game_type = 'national'
GROUP BY p.player_id
ORDER BY total_points DESC
LIMIT 10;

-- 2) Top 3 joueurs avec le meilleur FT% dans la finale du European Championship 2002
SELECT p.name, p.citizenship, s.ft_perc
FROM Player p
JOIN Player_Game_Stats s ON p.player_id = s.id_player
JOIN Game g ON s.id_game = g.id_game
JOIN Championship c ON g.id_championship = c.id_championship
WHERE c.name LIKE '%Championship%'
  AND c.year = 2002
ORDER BY s.ft_perc DESC
LIMIT 3;

-- 3) Club avec la plus grande taille moyenne
SELECT c.name AS club_name,
       ROUND(AVG(p.height), 2) AS avg_height
FROM Player p
JOIN Club c ON p.id_club = c.id_club
GROUP BY c.id_club
ORDER BY avg_height DESC
LIMIT 1;

-- 4) Sponsor ayant sponsorisé le plus d'équipes nationales gagnantes du World Championship
SELECT s.name AS sponsor_name,
       COUNT(DISTINCT ch.id_winner) AS nb_teams_sponsored
FROM Sponsor s
JOIN National_Team t ON s.id_beneficiary_team = t.id_team
JOIN Championship ch ON ch.id_winner = t.id_team
WHERE ch.name LIKE '%Championship%'
GROUP BY s.id_sponsor
ORDER BY nb_teams_sponsored DESC
LIMIT 1;

-- 5) Meilleurs shooteurs à 3 pts par club pour la saison 2023-2024 (moyenne)
WITH avg_3pts AS (
    SELECT p.id_club,
           p.player_id,
           AVG(s."3_pts_perc") AS avg_3pts_perc
    FROM Player p
    JOIN Player_Game_Stats s ON p.player_id = s.id_player
    JOIN Game g ON s.id_game = g.id_game
    JOIN Competition comp ON g.id_competition = comp.id_competition
    WHERE g.game_type = 'club'
      AND comp.season = '2023-2024'
    GROUP BY p.player_id
),
max_3pts AS (
    SELECT id_club, MAX(avg_3pts_perc) AS max_avg_3pts
    FROM avg_3pts
    GROUP BY id_club
)
SELECT c.name AS club_name,
       p.name AS player_name,
       a.avg_3pts_perc
FROM avg_3pts a
JOIN max_3pts m ON a.id_club = m.id_club AND a.avg_3pts_perc = m.max_avg_3pts
JOIN Player p ON a.player_id = p.player_id
JOIN Club c ON a.id_club = c.id_club
ORDER BY c.name;
