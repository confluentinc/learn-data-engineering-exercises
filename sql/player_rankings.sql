-- Create the output table
CREATE TABLE data_engineering.exercises.player_rankings (
    player_id          BIGINT NOT NULL,
    ranking            VARCHAR(20) NOT NULL,
    top_3_finish_rate  FLOAT NOT NULL,
    PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
    'connector'            = 'confluent',
    'changelog.mode'       = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format'           = 'json-registry',
    'value.format'         = 'json-registry',
    'value.fields-include' = 'all'
);

-- Calculate the ranking for each player based on their top 3 finish rate
INSERT INTO data_engineering.exercises.player_rankings
SELECT 
    player_id,
    CASE 
        WHEN top_3_finish_rate > 66 THEN 'expert'
        WHEN top_3_finish_rate BETWEEN 34 AND 66 THEN 'intermediate'
        ELSE 'beginner'
    END AS ranking,
    top_3_finish_rate
FROM 
    data_engineering.exercises.player_completion_statistics; 

-- Check the output
SELECT * FROM data_engineering.exercises.player_rankings;