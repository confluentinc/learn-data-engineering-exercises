-- Create the output table
CREATE TABLE `data-engineering`.`exercises`.`player_off_track_detection` (
    player_id       BIGINT NOT NULL,
    game_id         BIGINT NOT NULL,
    off_track_count BIGINT NOT NULL,
    place           BIGINT NOT NULL,
    window_start    TIMESTAMP(3) NOT NULL,
    window_end      TIMESTAMP(3) NOT NULL,
    PRIMARY KEY (player_id, game_id, window_start) NOT ENFORCED
) WITH (
    'connector'            = 'confluent',
    'changelog.mode'       = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format'           = 'json-registry',
    'value.format'         = 'json-registry',
    'value.fields-include' = 'all'
);

-- Calculate the off track count for each player in each game
-- Then, calculate the place for each player in each game
-- Then, join the off track counts and race positions using an interval join
-- And finally, filter for players with 4 or more off track counts and places 3 or lower
-- These players can be flagged as potential cheaters.
INSERT INTO `data-engineering`.`exercises`.`player_off_track_detection`
WITH off_track_counts AS (
    SELECT 
        player_id,
        game_id,
        COUNT(*) AS off_track_count,
        window_start,
        window_end,
        window_time
    FROM 
        TUMBLE (
            TABLE `data-engineering`.`exercises`.`player_activity`,
            DESCRIPTOR($rowtime),
            INTERVAL '1' MINUTE
        )
    WHERE 
        event_type = 'went_off_track'
    GROUP BY 
        player_id,
        game_id,
        window_start,
        window_end,
        window_time
),
race_positions AS (
    SELECT 
        player_id,
        game_id,
        current_place AS place,
        $rowtime AS event_time
    FROM 
        `data-engineering`.`exercises`.`player_activity`
    WHERE 
        event_type = 'completed_race'
)
SELECT 
    otc.player_id,
    otc.game_id,
    otc.off_track_count,
    rp.place,
    otc.window_start,
    otc.window_end
FROM 
    off_track_counts otc
    JOIN race_positions rp 
        ON otc.player_id = rp.player_id 
        AND otc.game_id = rp.game_id
        AND rp.event_time BETWEEN otc.window_time - INTERVAL '1' MINUTE AND otc.window_time + INTERVAL '10' MINUTE
WHERE otc.off_track_count >= 4 AND rp.place <= 3;

-- Check the output
SELECT * FROM `data-engineering`.`exercises`.`player_off_track_detection`;