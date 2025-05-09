-- Create the output table
CREATE TABLE `data-engineering`.`exercises`.`potential_churn` (
    player_id          BIGINT NOT NULL,
    name              VARCHAR(100) NOT NULL,
    username          VARCHAR(50) NOT NULL,
    last_login        TIMESTAMP_LTZ(3) NOT NULL,
    days_since_login  BIGINT NOT NULL,
    detection_date    TIMESTAMP_LTZ(3) NOT NULL,
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

-- Detect users who have not logged in for 90 days
INSERT INTO `data-engineering`.`exercises`.`potential_churn`
SELECT
    id AS player_id,
    name,
    username,
    last_login,
    TIMESTAMPDIFF(DAY, last_login, CURRENT_TIMESTAMP) AS days_since_login,
    CURRENT_TIMESTAMP AS detection_date
FROM 
    `data-engineering`.`exercises`.`players`
WHERE 
    last_login < CURRENT_TIMESTAMP - INTERVAL '90' DAY;

-- Check the output
SELECT * FROM `data-engineering`.`exercises`.`potential_churn`;