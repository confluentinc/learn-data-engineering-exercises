CREATE TABLE `data-engineering`.`exercises`.`player_completion_stats` (
    player_id BIGINT NOT NULL,
    finished_races BIGINT NOT NULL,
    first_place_finishes BIGINT NOT NULL,
    second_place_finishes BIGINT NOT NULL,
    third_place_finishes BIGINT NOT NULL,
    other_finishes BIGINT NOT NULL,
    top_3_finishes BIGINT NOT NULL,
    best_finish BIGINT NOT NULL,
    worst_finish BIGINT NOT NULL,
    average_finish BIGINT NOT NULL,
    first_place_rate FLOAT NOT NULL,
    second_place_rate FLOAT NOT NULL,
    third_place_rate FLOAT NOT NULL,
    other_finish_rate FLOAT NOT NULL,
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

INSERT INTO `data-engineering`.`exercises`.`player_completion_statistics`
WITH finish_positions AS (
    SELECT
        player_id,
        COUNT(*) as finished_races,
        COUNT(CASE WHEN current_place = 1 THEN 1 END) as first_place_finishes,
        COUNT(CASE WHEN current_place = 2 THEN 1 END) as second_place_finishes,
        COUNT(CASE WHEN current_place = 3 THEN 1 END) as third_place_finishes,
        COUNT(CASE WHEN current_place > 3 THEN 1 END) as other_finishes,
        COUNT(CASE WHEN current_place <= 3 THEN 1 END) as top_3_finishes,
        MIN(current_place) as best_finish,
        MAX(current_place) as worst_finish,
        AVG(current_place) as average_finish
    FROM `data-engineering`.`exercises`.`player_activity`
    WHERE event_type = 'completed_race'
    GROUP BY player_id
)
SELECT
    player_id,
    finished_races,
    first_place_finishes,
    second_place_finishes,
    third_place_finishes,
    other_finishes,
    top_3_finishes,
    best_finish,
    worst_finish,
    average_finish,
    ROUND(CAST(first_place_finishes AS FLOAT) / NULLIF(finished_races, 0) * 100, 2) as first_place_rate,
    ROUND(CAST(second_place_finishes AS FLOAT) / NULLIF(finished_races, 0) * 100, 2) as second_place_rate,
    ROUND(CAST(third_place_finishes AS FLOAT) / NULLIF(finished_races, 0) * 100, 2) as third_place_rate,
    ROUND(CAST(other_finishes AS FLOAT) / NULLIF(finished_races, 0) * 100, 2) as other_finish_rate,
    ROUND(CAST(top_3_finishes AS FLOAT) / NULLIF(finished_races, 0) * 100, 2) as top_3_finish_rate
FROM finish_positions;