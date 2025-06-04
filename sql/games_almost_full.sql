-- Create the output table
CREATE TABLE `data_engineering`.`exercises`.`games_almost_full` (
    window_start     TIMESTAMP(3) NOT NULL,
    window_end       TIMESTAMP(3) NOT NULL,
    game_id          BIGINT NOT NULL,
    game_type        STRING NOT NULL,
    track_name       STRING NOT NULL,
    max_players      BIGINT NOT NULL,
    current_players  BIGINT NOT NULL,
    remaining_spots  BIGINT NOT NULL,
    PRIMARY KEY (game_id, window_start) NOT ENFORCED
) WITH (
    'connector'            = 'confluent',
    'changelog.mode'       = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format'           = 'json-registry',
    'value.format'         = 'json-registry',
    'value.fields-include' = 'all'
);

-- Determine which games have less than 3 remaining spots and are waiting for players.
INSERT INTO `data_engineering`.`exercises`.`games_almost_full`
SELECT
    window_start,
    window_end,
    game_id,
    game_type,
    track_name,
    max_players,
    CARDINALITY(players) AS current_players,
    max_players - CARDINALITY(players) AS remaining_spots
FROM 
    TUMBLE (
        TABLE games,
        DESCRIPTOR($rowtime),
        INTERVAL '1' MINUTE
    )
WHERE
    max_players - CARDINALITY(players) <= 3
    AND game_status = 'waiting';

-- Check the output
SELECT * FROM data_engineering.exercises.games_almost_full;