CREATE TABLE `data-engineering`.`exercises`.`player_rankings` (
    player_id BIGINT NOT NULL,
    ranking VARCHAR(20) NOT NULL,
    top_3_finish_rate FLOAT NOT NULL,
    PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
    'connector' = 'confluent',
    'changelog.mode' = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format' = 'json-registry',
    'value.format' = 'json-registry',
    'value.fields-include' = 'all'
);

SELECT 
    player_id,
    CASE 
        WHEN top_3_finish_rate > 66 THEN 'expert'
        WHEN top_3_finish_rate BETWEEN 34 AND 66 THEN 'intermediate'
        ELSE 'beginner'
    END as ranking,
    top_3_finish_rate
FROM `data-engineering`.`exercises`.`player_completion_stats`; 