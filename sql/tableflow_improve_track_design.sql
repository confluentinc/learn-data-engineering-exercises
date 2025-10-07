-- Find tracks to improve 
WITH player_games AS (
  SELECT 
    player_id,
    track_name,
    current_place,
    DENSE_RANK() OVER (PARTITION BY player_id ORDER BY player_activity."$$timestamp") AS game_sequence
  FROM player_activity
  LEFT JOIN games ON player_activity.game_id = games.game_id
  WHERE event_type = 'completed_race'
), 
player_track_performance AS (
  SELECT 
    player_id,
    track_name,
    -- Calculate improvement rate using linear regression for this specific track
    regr_slope(current_place, game_sequence) AS track_improvement
  FROM player_games
  GROUP BY player_id, track_name
),
player_overall_performance AS (
  SELECT 
    player_id,
    -- Calculate overall improvement across all tracks for each player
    regr_slope(current_place, game_sequence) AS overall_improvement
  FROM player_games
  GROUP BY player_id
),
track_quality AS (
  SELECT 
    t.track_name,
    -- Average improvement rate for this track
    AVG(t.track_improvement) AS avg_track_improvement,
    -- How much this track differs from player's overall improvement
    AVG(t.track_improvement - o.overall_improvement) AS improvement_gap,
    COUNT(*) AS player_count
  FROM player_track_performance t
  JOIN player_overall_performance o ON t.player_id = o.player_id
  WHERE o.overall_improvement > 0  -- Only players who are improving overall
  GROUP BY t.track_name
)
SELECT 
  track_name,
  avg_track_improvement,
  improvement_gap,
  -- Track quality score (negative = poorly designed)
  CASE 
    WHEN improvement_gap < -0.5 THEN 'Poorly Designed'
    WHEN improvement_gap < -0.2 THEN 'Needs Improvement' 
    ELSE 'Well Designed'
  END AS design_quality
FROM track_quality
WHERE player_count >= 10  -- Minimum sample size
ORDER BY improvement_gap ASC;
