CREATE TABLE `data-engineering`.`exercises`.`retention_by_month` (
    signup_month VARCHAR(7) NOT NULL,
    total_signups BIGINT NOT NULL,
    month_1_retention DOUBLE NOT NULL,
    month_3_retention DOUBLE NOT NULL, 
    month_6_retention DOUBLE NOT NULL,
    month_9_retention DOUBLE NOT NULL,
    month_12_retention DOUBLE NOT NULL,
    PRIMARY KEY (signup_month) NOT ENFORCED
) WITH (
    'connector' = 'confluent',
    'changelog.mode' = 'upsert',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '1 h',
    'key.format' = 'json-registry',
    'value.format' = 'json-registry',
    'value.fields-include' = 'all'
);

-- Determine the retention periods grouped by signup month

INSERT INTO `data-engineering`.`exercises`.`retention_by_month`
WITH player_months AS (
    SELECT
        id,
        DATE_FORMAT(creation_date, 'yyyy-MM') as signup_month,
        DATE_FORMAT(last_login, 'yyyy-MM') as last_login_month,
        TIMESTAMPDIFF(MONTH, creation_date, last_login) as months_retained
    FROM `data-engineering`.`exercises`.`players`
)
SELECT
    signup_month,
    COUNT(*) as total_signups,
    SUM(CASE WHEN months_retained >= 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as month_1_retention,
    SUM(CASE WHEN months_retained >= 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as month_3_retention,
    SUM(CASE WHEN months_retained >= 6 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as month_6_retention,
    SUM(CASE WHEN months_retained >= 9 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as month_9_retention,
    SUM(CASE WHEN months_retained >= 12 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as month_12_retention
FROM player_months
GROUP BY signup_month;