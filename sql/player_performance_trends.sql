-- Create a table to track player performance trends over time
CREATE TABLE `data-engineering`.`exercises`.`player_performance_trends` (
    player_id BIGINT NOT NULL,
    window_start TIMESTAMP(3) NOT NULL,
    window_end TIMESTAMP(3) NOT NULL,
    races_in_window BIGINT NOT NULL,
    avg_finish_position FLOAT NOT NULL,
    previous_avg_finish_position FLOAT,
    top_3_rate FLOAT,
    performance_trend VARCHAR(20) NOT NULL,
    PRIMARY KEY (player_id, window_start) NOT ENFORCED
) WITH (
    'connector' = 'confluent',
    'changelog.mode' = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format' = 'json-registry',
    'value.format' = 'json-registry',
    'value.fields-include' = 'all'
);

INSERT INTO `data-engineering`.`exercises`.`player_performance_trends`
WITH current_and_previous AS (
    SELECT
        player_id,
        window_start,
        window_end,
        COUNT(*) AS races_in_window,
        (COUNT(CASE WHEN current_place <= 3 THEN 1 END) * 100.0 / COUNT(*)) AS top_3_rate,
        AVG(current_place) AS avg_finish_position,
        LAG(AVG(current_place), 1) OVER (
            PARTITION BY player_id 
            ORDER BY window_time
        ) AS previous_avg_finish_position
    FROM TUMBLE(
        TABLE `data-engineering`.`exercises`.`player_activity`,
        DESCRIPTOR($rowtime),
        INTERVAL '1' MINUTE
    )
    WHERE event_type = 'completed_race'
    GROUP BY 
        player_id,
        window_start,
        window_end,
        window_time
    HAVING COUNT(*) > 0
)
SELECT
    player_id,
    window_start,
    window_end,
    races_in_window,
    avg_finish_position,
    previous_avg_finish_position,
    top_3_rate,
    CASE
        WHEN previous_avg_finish_position IS NULL THEN 'new'
        WHEN avg_finish_position < previous_avg_finish_position THEN 'improving'
        WHEN avg_finish_position > previous_avg_finish_position THEN 'declining'
        ELSE 'stable'
    END AS performance_trend
FROM current_and_previous;