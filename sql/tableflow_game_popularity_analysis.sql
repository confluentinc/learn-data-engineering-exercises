-- Track popularity analysis
SELECT 
    g.track_name,
    g.game_type,
    COUNT(*) AS total_games,
    ROUND(AVG(CARDINALITY(g.players)),1) AS avg_players_per_game,
    MAX(CARDINALITY(g.players)) AS max_players_per_game,
    COUNT(CASE WHEN g.game_status = 'waiting' THEN 1 END) AS waiting_games,
    COUNT(CASE WHEN g.game_status = 'in_progress' THEN 1 END) AS active_games,
    COUNT(CASE WHEN g.game_status = 'completed' THEN 1 END) AS completed_games
FROM games g
GROUP BY g.track_name, g.game_type
ORDER BY avg_players_per_game DESC;
