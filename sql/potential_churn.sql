-- Detect users who have not logged in for 90 days

SELECT
    id AS player_id,
    name,
    username,
    last_login,
    TIMESTAMPDIFF(DAY, last_login, CURRENT_TIMESTAMP) as days_since_login,
    CURRENT_TIMESTAMP AS detection_date
FROM `data-engineering`.`exercises`.`players`
WHERE last_login < CURRENT_TIMESTAMP - INTERVAL '90' DAY;

-- Create a table to store the potential churn data

CREATE TABLE `data-engineering`.`exercises`.`potential_churn` (
    player_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL,
    last_login TIMESTAMP_LTZ(3) NOT NULL,
    days_since_login BIGINT NOT NULL,
    detection_date TIMESTAMP_LTZ(3) NOT NULL,
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

-- Insert the potential churn data into the table

INSERT INTO `data-engineering`.`exercises`.`potential_churn`
SELECT
    id AS player_id,
    name,
    username,
    last_login,
    TIMESTAMPDIFF(DAY, last_login, CURRENT_TIMESTAMP) as days_since_login,
    CURRENT_TIMESTAMP AS detection_date
FROM `data-engineering`.`exercises`.`players`
WHERE last_login < CURRENT_TIMESTAMP - INTERVAL '90' DAY;

-- Query the potential churn data

SELECT * FROM `data-engineering`.`exercises`.`potential_churn`;