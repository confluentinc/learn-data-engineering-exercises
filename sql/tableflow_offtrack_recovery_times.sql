-- Analyze recovery times from off-track events
WITH recovery_times AS (
  SELECT 
    g.track_name,
    pa1.player_id,
    pa1.game_id,
    date_diff('second', pa1."$$timestamp", pa2."$$timestamp") AS seconds_to_complete
  FROM player_activity pa1
  JOIN player_activity pa2 ON pa1.player_id = pa2.player_id 
    AND pa1.game_id = pa2.game_id
  JOIN games g ON pa1.game_id = g.game_id
  WHERE pa1.event_type = 'went_off_track'
    AND pa2.event_type = 'completed_race'
    AND pa2."$$timestamp" > pa1."$$timestamp"
)
SELECT 
  track_name,
  COUNT(*) AS off_track_to_completion_events,
  ROUND(AVG(seconds_to_complete), 1) AS avg_seconds_to_complete,
  MIN(seconds_to_complete) AS fastest_recovery,
  MAX(seconds_to_complete) AS slowest_recovery
FROM recovery_times
GROUP BY track_name
ORDER BY avg_seconds_to_complete DESC;
