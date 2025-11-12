-- Joueurs avec le plus grand total de points pour leur équipe nationale
SELECT 
    p.name AS player_name,
    nt.country AS national_team,
    SUM(pi.pts_3_md * 3 + pi.pts_2_md * 2 + pi.ft_md) AS total_points
FROM Player p
JOIN Plays_in pi ON p.ID_Pla = pi.ID_Pla
JOIN NT_Plays_in ntp 
  ON pi.ID_Gam = ntp.ID_Gam 
 AND p.ID_Nat = ntp.ID_Nat
JOIN National_Team nt ON nt.ID_Nat = ntp.ID_Nat
GROUP BY p.ID_Pla, nt.country
ORDER BY total_points DESC
LIMIT 10;


-- Les 3 joueurs avec le meilleur % de lancers francs dans la finale du Championnat d’Europe 2002
SELECT 
    p.name,
    pi.ft_perc AS free_throw_percentage
FROM Player p
JOIN Plays_in pi ON p.ID_Pla = pi.ID_Pla
JOIN Game g ON pi.ID_Gam = g.ID_Gam
JOIN Competition c ON g.ID_Com = c.ID_Com
WHERE c.name = 'EuroBasket'
  AND c.season = '2002'
  AND g.game_type = 'finale'
ORDER BY pi.ft_perc DESC
LIMIT 3;


-- Club ayant la taille moyenne de joueurs la plus élevée
SELECT 
    c.name AS club_name,
    ROUND(AVG(p.height), 1) AS average_height
FROM Club c
JOIN Plays_for_Club pc ON c.ID_Clu = pc.ID_Clu
JOIN Player p ON p.ID_Pla = pc.ID_Pla
GROUP BY c.ID_Clu
ORDER BY average_height DESC
LIMIT 1;


-- Sponsor ayant sponsorisé le plus d’équipes nationales qui ont gagné le Championnat du Monde
SELECT 
    s.name AS sponsor_name,
    COUNT(DISTINCT sn.ID_Nat) AS nb_winning_teams
FROM Sponsors_NT sn
JOIN Sponsor s ON sn.ID_Spo = s.ID_Spo
JOIN NT_Plays_in ntp ON sn.ID_Nat = ntp.ID_Nat
JOIN Game g ON ntp.ID_Gam = g.ID_Gam
JOIN Competition c ON g.ID_Com = c.ID_Com
WHERE c.name = 'World Championship'
  AND g.game_type = 'finale'
  AND ntp.win = 'yes'
GROUP BY s.ID_Spo
ORDER BY nb_winning_teams DESC
LIMIT 1;


-- Pour chaque club, joueurs avec le meilleur % de tirs à 3 points dans la saison en cours (ex: '2024-2025')
SELECT 
    c.name AS club_name,
    p.name AS player_name,
    MAX(pi.pts_3_perc) AS best_3pt_percentage
FROM Club c
JOIN Plays_for_Club pfc ON c.ID_Clu = pfc.ID_Clu
JOIN Player p ON p.ID_Pla = pfc.ID_Pla
JOIN Plays_in pi ON p.ID_Pla = pi.ID_Pla
JOIN Game g ON pi.ID_Gam = g.ID_Gam
JOIN Competition co ON g.ID_Com = co.ID_Com
WHERE co.season = '2024-2025'
GROUP BY c.ID_Clu;


-- Pour un club particulier (ex: FC Barcelona), le joueur avec le plus grand nombre moyen de passes décisives
SELECT 
    p.name AS player_name,
    ROUND(AVG(pi.assists), 2) AS avg_assists_per_game
FROM Player p
JOIN Plays_for_Club pfc ON p.ID_Pla = pfc.ID_Pla
JOIN Club c ON pfc.ID_Clu = c.ID_Clu
JOIN Plays_in pi ON p.ID_Pla = pi.ID_Pla
JOIN Club_Plays_in cpi ON pi.ID_Gam = cpi.ID_Gam AND cpi.ID_Clu = c.ID_Clu
WHERE c.name = 'FC Barcelona'
GROUP BY p.ID_Pla
ORDER BY avg_assists_per_game DESC
LIMIT 1;


-- Clubs ayant gagné l’Euroleague plus de 3 fois
SELECT 
    c.name AS club_name,
    COUNT(*) AS wins
FROM Club c
JOIN Club_Plays_in cpi ON c.ID_Clu = cpi.ID_Clu
JOIN Game g ON cpi.ID_Gam = g.ID_Gam
JOIN Competition co ON g.ID_Com = co.ID_Com
WHERE co.name = 'Euroleague'
  AND g.game_type = 'finale'
  AND cpi.win = 'yes'
GROUP BY c.ID_Clu
HAVING COUNT(*) > 3
ORDER BY wins DESC;
