-- Check the players table
SELECT COUNT(*) as total_players, 
       MIN(creation_date) as earliest_player,
       MAX(last_login) as most_recent_login
FROM players;
