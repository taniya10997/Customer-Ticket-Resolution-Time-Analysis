--  Create & Use Database
CREATE DATABASE customer_ticket_project;
USE customer_ticket_project;


-- Create staging tables (ALL VARCHAR)

CREATE TABLE agent_stg (
  agent_id              VARCHAR(255),
  agent_name            VARCHAR(255),
  email                 VARCHAR(255),
  phone                 VARCHAR(255),
  department_id         VARCHAR(255),
  experience_years      VARCHAR(255),
  rating                VARCHAR(255),
  experience_bucket     VARCHAR(255),
  rating_bucket         VARCHAR(255),
  top_performer_flag    VARCHAR(255)
);

CREATE TABLE category_stg (
  category_name         VARCHAR(255),
  severity              VARCHAR(255),
  category_id           VARCHAR(255),
  severity_level        VARCHAR(255)
);

CREATE TABLE customer_stg (
  customer_id               VARCHAR(255),
  customer_name             VARCHAR(255),
  email                     VARCHAR(255),
  phone                     VARCHAR(255),
  city                      VARCHAR(255),
  state                     VARCHAR(255),
  is_number_missing         VARCHAR(255),
  signup_date               VARCHAR(255),
  customer_tenure_days      VARCHAR(255),
  customer_type             VARCHAR(255),
  signup_year               VARCHAR(255),
  signup_month              VARCHAR(255),
  signup_quater             VARCHAR(255),
  customer_tenure_bucket    VARCHAR(255)
);

CREATE TABLE department_stg (
  department_id         VARCHAR(255),
  department_name       VARCHAR(255),
  location              VARCHAR(255),
  department_code       VARCHAR(255),
  department_type       VARCHAR(255),
  region                VARCHAR(255),
  Department_Location   VARCHAR(255),
  Is_Active             VARCHAR(255)
);

CREATE TABLE status_stg (
  status_id             VARCHAR(255),
  status_name           VARCHAR(255),
  status_order          VARCHAR(255),
  status_type           VARCHAR(255),
  is_closed_flag        VARCHAR(255)
);

CREATE TABLE ticket_stg (
  ticket_id             VARCHAR(255),
  priority              VARCHAR(255),
  customer_satisfaction VARCHAR(255),
  created_date          VARCHAR(255),
  resolved_date         VARCHAR(255),
  resolved_status       VARCHAR(255),
  sla_status            VARCHAR(255),
  ticket_status         VARCHAR(255),
  is_closed_flag        VARCHAR(255),
  status_id             VARCHAR(255),
  resolution_bucket     VARCHAR(255),
  Year                  VARCHAR(255),
  createddateonly       VARCHAR(255),
  AgentName_Clean       VARCHAR(255),
  department_id         VARCHAR(255),
  category_id           VARCHAR(255),
  agent_name            VARCHAR(255),
  agent_id              VARCHAR(255),
  customer_id           VARCHAR(255),
  resolution_time_hour  VARCHAR(255),
  resolution_days       VARCHAR(255)
);
SHOW TABLES;
SELECT 'department_stg' AS table_name, COUNT(*) AS rows_count FROM department_stg
UNION ALL
SELECT 'agent_stg', COUNT(*) FROM agent_stg
UNION ALL
SELECT 'category_stg', COUNT(*) FROM category_stg
UNION ALL
SELECT 'status_stg', COUNT(*) FROM status_stg
UNION ALL
SELECT 'customer_stg', COUNT(*) FROM customer_stg
UNION ALL
SELECT 'ticket_stg', COUNT(*) FROM ticket_stg;

-- 1) Department
CREATE TABLE dim_department AS
SELECT
  CAST(NULLIF(TRIM(department_id),'') AS UNSIGNED)     AS department_id,
  NULLIF(TRIM(department_name),'')                    AS department_name,
  NULLIF(TRIM(location),'')                           AS location,
  NULLIF(TRIM(department_code),'')                    AS department_code,
  NULLIF(TRIM(department_type),'')                    AS department_type,
  NULLIF(TRIM(region),'')                             AS region,
  NULLIF(TRIM(Department_Location),'')                AS department_location,
  CASE
    WHEN LOWER(TRIM(Is_Active)) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(TRIM(Is_Active)) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END                                                AS is_active
FROM department_stg;

ALTER TABLE dim_department
  ADD PRIMARY KEY (department_id);
  
  -- 2) Agent
CREATE TABLE dim_agent AS
SELECT
  CAST(NULLIF(TRIM(agent_id),'') AS UNSIGNED)          AS agent_id,
  NULLIF(TRIM(agent_name),'')                         AS agent_name,
  NULLIF(TRIM(email),'')                              AS email,
  NULLIF(TRIM(phone),'')                              AS phone,
  CAST(NULLIF(TRIM(department_id),'') AS UNSIGNED)     AS department_id,
  CAST(NULLIF(TRIM(experience_years),'') AS DECIMAL(5,2)) AS experience_years,
  CAST(NULLIF(TRIM(rating),'') AS DECIMAL(5,2))        AS rating,
  NULLIF(TRIM(experience_bucket),'')                   AS experience_bucket,
  NULLIF(TRIM(rating_bucket),'')                       AS rating_bucket,
  CASE
    WHEN LOWER(TRIM(top_performer_flag)) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(TRIM(top_performer_flag)) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END                                                 AS top_performer_flag
FROM agent_stg;

ALTER TABLE dim_agent
  ADD PRIMARY KEY (agent_id);
  
  -- 3) Category
CREATE TABLE dim_category AS
SELECT
  CAST(NULLIF(TRIM(category_id),'') AS UNSIGNED)       AS category_id,
  NULLIF(TRIM(category_name),'')                      AS category_name,
  NULLIF(TRIM(severity),'')                           AS severity,
  NULLIF(TRIM(severity_level),'')                     AS severity_level
FROM category_stg;

ALTER TABLE dim_category
  ADD PRIMARY KEY (category_id);
  
  -- 4) Status
CREATE TABLE dim_status AS
SELECT
  CAST(NULLIF(TRIM(status_id),'') AS UNSIGNED)         AS status_id,
  NULLIF(TRIM(status_name),'')                        AS status_name,
  CAST(NULLIF(TRIM(status_order),'') AS UNSIGNED)      AS status_order,
  NULLIF(TRIM(status_type),'')                        AS status_type,
  CASE
    WHEN LOWER(TRIM(is_closed_flag)) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(TRIM(is_closed_flag)) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END                                                 AS is_closed_flag
FROM status_stg;

ALTER TABLE dim_status
  ADD PRIMARY KEY (status_id);

-- 5) Customer
CREATE TABLE dim_customer AS
SELECT
  CAST(NULLIF(TRIM(customer_id),'') AS UNSIGNED)       AS customer_id,
  NULLIF(TRIM(customer_name),'')                      AS customer_name,
  NULLIF(TRIM(email),'')                              AS email,
  NULLIF(TRIM(phone),'')                              AS phone,
  NULLIF(TRIM(city),'')                               AS city,
  NULLIF(TRIM(state),'')                              AS state,
  CASE
    WHEN LOWER(TRIM(is_number_missing)) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(TRIM(is_number_missing)) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END                                                 AS is_number_missing,
  -- signup_date: try parse common formats
  CASE
    WHEN signup_date IS NULL OR TRIM(signup_date)='' THEN NULL
    WHEN signup_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN STR_TO_DATE(signup_date,'%Y-%m-%d')
    WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}' THEN STR_TO_DATE(signup_date,'%d-%m-%Y')
    WHEN signup_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}' THEN STR_TO_DATE(signup_date,'%d/%m/%Y')
    ELSE NULL
  END                                                 AS signup_date,
  CAST(NULLIF(TRIM(customer_tenure_days),'') AS UNSIGNED) AS customer_tenure_days,
  NULLIF(TRIM(customer_type),'')                      AS customer_type,
  CAST(NULLIF(TRIM(signup_year),'') AS UNSIGNED)      AS signup_year,
  NULLIF(TRIM(signup_month),'')                       AS signup_month,
  NULLIF(TRIM(signup_quater),'')                      AS signup_quarter,
  NULLIF(TRIM(customer_tenure_bucket),'')             AS customer_tenure_bucket
FROM customer_stg;

ALTER TABLE dim_customer
  ADD PRIMARY KEY (customer_id);
  
 
  CREATE TABLE dim_customer AS
SELECT
  CAST(NULLIF(TRIM(customer_id),'') AS UNSIGNED) AS customer_id,
  NULLIF(TRIM(customer_name),'') AS customer_name,
  NULLIF(TRIM(email),'') AS email,
  NULLIF(TRIM(phone),'') AS phone,
  NULLIF(TRIM(city),'') AS city,
  NULLIF(TRIM(state),'') AS state,
  CASE
    WHEN LOWER(TRIM(is_number_missing)) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(TRIM(is_number_missing)) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END AS is_number_missing,

  STR_TO_DATE(signup_date, '%Y-%m-%d %H:%i:%s') AS signup_date,

  CAST(NULLIF(TRIM(customer_tenure_days),'') AS UNSIGNED) AS customer_tenure_days,
  NULLIF(TRIM(customer_type),'') AS customer_type,
  CAST(NULLIF(TRIM(signup_year),'') AS UNSIGNED) AS signup_year,
  NULLIF(TRIM(signup_month),'') AS signup_month,
  NULLIF(TRIM(signup_quater),'') AS signup_quarter,
  NULLIF(TRIM(customer_tenure_bucket),'') AS customer_tenure_bucket
FROM customer_stg;


SELECT @@SESSION.sql_mode;
SET SESSION sql_mode = REPLACE(@@SESSION.sql_mode, 'STRICT_TRANS_TABLES', '');
SET SESSION sql_mode = REPLACE(@@SESSION.sql_mode, 'STRICT_ALL_TABLES', '');

  SELECT DISTINCT signup_date
FROM customer_stg
WHERE signup_date IS NOT NULL
LIMIT 20;

  DROP TABLE IF EXISTS dim_customer;

  
  CREATE TABLE dim_customer AS
SELECT
  CAST(customer_id AS UNSIGNED) AS customer_id,
  customer_name,
  email,
  phone,
  city,
  state,

  CASE
    WHEN LOWER(is_number_missing) IN ('1','true','yes','y') THEN 1
    WHEN LOWER(is_number_missing) IN ('0','false','no','n') THEN 0
    ELSE NULL
  END AS is_number_missing,

  CAST(signup_date AS DATETIME) AS signup_date,

  CAST(customer_tenure_days AS UNSIGNED) AS customer_tenure_days,
  customer_type,
  CAST(signup_year AS UNSIGNED) AS signup_year,
  signup_month,
  signup_quater AS signup_quarter,
  customer_tenure_bucket
FROM customer_stg;

ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_id);


  SELECT customer_id, signup_date
FROM dim_customer
WHERE signup_date IS NULL
LIMIT 20;

  DELETE FROM dim_customer
WHERE customer_id = 0;

  

CREATE TABLE fact_ticket AS
SELECT
  CAST(ticket_id AS UNSIGNED) AS ticket_id,

  CAST(customer_id AS UNSIGNED) AS customer_id,
  CAST(agent_id AS UNSIGNED) AS agent_id,
  CAST(category_id AS UNSIGNED) AS category_id,
  CAST(department_id AS UNSIGNED) AS department_id,
  CAST(status_id AS UNSIGNED) AS status_id,

  priority,
  customer_satisfaction,
  sla_status,
  ticket_status,
  resolved_status,
  resolution_bucket,
  Year,

  -- Convert to DATETIME
  CAST(created_date AS DATETIME) AS created_date,
  CAST(resolved_date AS DATETIME) AS resolved_date,

  -- SAFE resolution hours (negative avoid)
  CASE
    WHEN resolved_date IS NULL THEN NULL
    WHEN CAST(resolved_date AS DATETIME) < CAST(created_date AS DATETIME) THEN NULL
    ELSE TIMESTAMPDIFF(SECOND,
         CAST(created_date AS DATETIME),
         CAST(resolved_date AS DATETIME)
    ) / 3600
  END AS resolution_time_hour,

  -- SAFE resolution days
  CASE
    WHEN resolved_date IS NULL THEN NULL
    WHEN CAST(resolved_date AS DATETIME) < CAST(created_date AS DATETIME) THEN NULL
    ELSE DATEDIFF(
         CAST(resolved_date AS DATETIME),
         CAST(created_date AS DATETIME)
    )
  END AS resolution_days

FROM ticket_stg;

  DROP TABLE IF EXISTS fact_ticket;

  CREATE TABLE fact_ticket AS
SELECT
  CAST(NULLIF(TRIM(ticket_id),'') AS UNSIGNED) AS ticket_id,

  CAST(NULLIF(TRIM(customer_id),'') AS UNSIGNED) AS customer_id,
  CAST(NULLIF(TRIM(agent_id),'') AS UNSIGNED) AS agent_id,
  CAST(NULLIF(TRIM(category_id),'') AS UNSIGNED) AS category_id,
  CAST(NULLIF(TRIM(department_id),'') AS UNSIGNED) AS department_id,
  CAST(NULLIF(TRIM(status_id),'') AS UNSIGNED) AS status_id,

  NULLIF(TRIM(priority),'') AS priority,
  NULLIF(TRIM(customer_satisfaction),'') AS customer_satisfaction,
  NULLIF(TRIM(sla_status),'') AS sla_status,
  NULLIF(TRIM(ticket_status),'') AS ticket_status,
  NULLIF(TRIM(resolved_status),'') AS resolved_status,
  NULLIF(TRIM(resolution_bucket),'') AS resolution_bucket,
  CAST(NULLIF(TRIM(Year),'') AS UNSIGNED) AS year,

  -- ✅ created_date safe
  CASE
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN TRIM(created_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
      THEN CAST(TRIM(created_date) AS DATETIME)
    WHEN TRIM(created_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      THEN CAST(CONCAT(TRIM(created_date),' 00:00:00') AS DATETIME)
    ELSE NULL
  END AS created_date,

  -- ✅ resolved_date safe
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN TRIM(resolved_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
      THEN CAST(TRIM(resolved_date) AS DATETIME)
    WHEN TRIM(resolved_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      THEN CAST(CONCAT(TRIM(resolved_date),' 00:00:00') AS DATETIME)
    ELSE NULL
  END AS resolved_date,

  -- ✅ resolution_time_hour safe (no negative)
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN (CAST(TRIM(resolved_date) AS DATETIME) < CAST(TRIM(created_date) AS DATETIME)) THEN NULL
    ELSE TIMESTAMPDIFF(SECOND, CAST(TRIM(created_date) AS DATETIME), CAST(TRIM(resolved_date) AS DATETIME))/3600
  END AS resolution_time_hour,

  -- ✅ resolution_days safe
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN (CAST(TRIM(resolved_date) AS DATETIME) < CAST(TRIM(created_date) AS DATETIME)) THEN NULL
    ELSE DATEDIFF(CAST(TRIM(resolved_date) AS DATETIME), CAST(TRIM(created_date) AS DATETIME))
  END AS resolution_days

FROM ticket_stg;

ALTER TABLE fact_ticket
ADD PRIMARY KEY (ticket_id);

 #Total rows
SELECT COUNT(*) AS total_rows
FROM fact_ticket;
  
  #ceated date NULL kitni?
SELECT COUNT(*) AS created_null
FROM fact_ticket
WHERE created_date IS NULL;
  
  SELECT COUNT(*) AS resolved_null
FROM fact_ticket
WHERE resolved_date IS NULL;

  SELECT COUNT(*) AS negative_hours
FROM fact_ticket
WHERE resolution_time_hour < 0;

  #reated_date ke sample values
SELECT created_date
FROM ticket_stg
WHERE created_date IS NOT NULL AND TRIM(created_date) <> ''
LIMIT 20;
  
 ##esolved_date ke sample values
SELECT resolved_date
FROM ticket_stg
WHERE resolved_date IS NOT NULL AND TRIM(resolved_date) <> ''
LIMIT 20;

DROP TABLE IF EXISTS fact_ticket;

CREATE TABLE fact_ticket AS
SELECT
  CAST(NULLIF(TRIM(ticket_id),'') AS UNSIGNED) AS ticket_id,

  CAST(NULLIF(TRIM(customer_id),'') AS UNSIGNED) AS customer_id,
  CAST(NULLIF(TRIM(agent_id),'') AS UNSIGNED) AS agent_id,
  CAST(NULLIF(TRIM(category_id),'') AS UNSIGNED) AS category_id,
  CAST(NULLIF(TRIM(department_id),'') AS UNSIGNED) AS department_id,
  CAST(NULLIF(TRIM(status_id),'') AS UNSIGNED) AS status_id,

  NULLIF(TRIM(priority),'') AS priority,
  NULLIF(TRIM(customer_satisfaction),'') AS customer_satisfaction,
  NULLIF(TRIM(sla_status),'') AS sla_status,
  NULLIF(TRIM(ticket_status),'') AS ticket_status,
  NULLIF(TRIM(resolved_status),'') AS resolved_status,
  NULLIF(TRIM(resolution_bucket),'') AS resolution_bucket,
  CAST(NULLIF(TRIM(Year),'') AS UNSIGNED) AS year,

  /*  created_date: 'DD-MM-YYYY HH:MM' */
  CASE
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN TRIM(created_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}$'
      THEN STR_TO_DATE(TRIM(created_date), '%d-%m-%Y %H:%i')
    ELSE NULL
  END AS created_date,

  /*  resolved_date: 'DD-MM-YYYY HH:MM' */
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN TRIM(resolved_date) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}$'
      THEN STR_TO_DATE(TRIM(resolved_date), '%d-%m-%Y %H:%i')
    ELSE NULL
  END AS resolved_date,

  /*  resolution_time_hour safe */
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN STR_TO_DATE(TRIM(resolved_date), '%d-%m-%Y %H:%i')
       < STR_TO_DATE(TRIM(created_date), '%d-%m-%Y %H:%i') THEN NULL
    ELSE TIMESTAMPDIFF(
      SECOND,
      STR_TO_DATE(TRIM(created_date), '%d-%m-%Y %H:%i'),
      STR_TO_DATE(TRIM(resolved_date), '%d-%m-%Y %H:%i')
    )/3600
  END AS resolution_time_hour,

  /*  resolution_days safe */
  CASE
    WHEN resolved_date IS NULL OR TRIM(resolved_date)='' THEN NULL
    WHEN created_date IS NULL OR TRIM(created_date)='' THEN NULL
    WHEN STR_TO_DATE(TRIM(resolved_date), '%d-%m-%Y %H:%i')
       < STR_TO_DATE(TRIM(created_date), '%d-%m-%Y %H:%i') THEN NULL
    ELSE DATEDIFF(
      STR_TO_DATE(TRIM(resolved_date), '%d-%m-%Y %H:%i'),
      STR_TO_DATE(TRIM(created_date), '%d-%m-%Y %H:%i')
    )
  END AS resolution_days

FROM ticket_stg;

ALTER TABLE fact_ticket
ADD PRIMARY KEY (ticket_id);

SELECT COUNT(*) AS total_rows FROM fact_ticket;

SELECT created_date, resolved_date, resolution_time_hour, resolution_days
FROM fact_ticket
LIMIT 5;


-- customer mismatch
SELECT COUNT(*) AS customer_missing
FROM fact_ticket f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE f.customer_id IS NOT NULL AND c.customer_id IS NULL;

-- agent mismatch
SELECT COUNT(*) AS agent_missing
FROM fact_ticket f
LEFT JOIN dim_agent a ON f.agent_id = a.agent_id
WHERE f.agent_id IS NOT NULL AND a.agent_id IS NULL;

-- category mismatch
SELECT COUNT(*) AS category_missing
FROM fact_ticket f
LEFT JOIN dim_category cat ON f.category_id = cat.category_id
WHERE f.category_id IS NOT NULL AND cat.category_id IS NULL;

-- department mismatch
SELECT COUNT(*) AS department_missing
FROM fact_ticket f
LEFT JOIN dim_department d ON f.department_id = d.department_id
WHERE f.department_id IS NOT NULL AND d.department_id IS NULL;

-- status mismatch
SELECT COUNT(*) AS status_missing
FROM fact_ticket f
LEFT JOIN dim_status s ON f.status_id = s.status_id
WHERE f.status_id IS NOT NULL AND s.status_id IS NULL;
##ssing customers ka sample nikaalo
SELECT f.customer_id, COUNT(*) AS tickets
FROM fact_ticket f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE f.customer_id IS NOT NULL AND c.customer_id IS NULL
GROUP BY f.customer_id
ORDER BY tickets DESC
LIMIT 20;

UPDATE fact_ticket
SET customer_id = NULL
WHERE customer_id = 0;

SELECT COUNT(*) AS customer_missing
FROM fact_ticket f
LEFT JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE f.customer_id IS NOT NULL AND c.customer_id IS NULL;

CREATE INDEX idx_ft_customer ON fact_ticket(customer_id);
CREATE INDEX idx_ft_agent ON fact_ticket(agent_id);
CREATE INDEX idx_ft_category ON fact_ticket(category_id);
CREATE INDEX idx_ft_department ON fact_ticket(department_id);
CREATE INDEX idx_ft_status ON fact_ticket(status_id);

ALTER TABLE fact_ticket
  ADD CONSTRAINT fk_ft_customer
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
  ADD CONSTRAINT fk_ft_agent
    FOREIGN KEY (agent_id) REFERENCES dim_agent(agent_id),
  ADD CONSTRAINT fk_ft_category
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
  ADD CONSTRAINT fk_ft_department
    FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
  ADD CONSTRAINT fk_ft_status
    FOREIGN KEY (status_id) REFERENCES dim_status(status_id);
    
    
    CREATE OR REPLACE VIEW vw_fact_ticket AS
SELECT
    f.*,
    -- status name (column name agar different ho to change kar dena)
    s.status_name,
    -- closed flag derived from status
    CASE WHEN LOWER(TRIM(s.status_name)) = 'closed' THEN 1 ELSE 0 END AS is_closed_flag,
    -- open flag
    CASE WHEN LOWER(TRIM(s.status_name)) = 'closed' THEN 0 ELSE 1 END AS is_open_flag
FROM fact_ticket f
LEFT JOIN dim_status s
    ON f.status_id = s.status_id;

    
#Dashboard1
# Q1) Executive KPIs (Total, Closed, Open, Closed %)Use for: Top 4 KPI cards

SELECT
    COUNT(*) AS total_tickets,
    SUM(is_closed_flag) AS closed_tickets,
    SUM(is_open_flag)  AS open_tickets,
    ROUND(100 * SUM(is_closed_flag) / COUNT(*), 2) AS closed_pct
FROM vw_fact_ticket;

#Q2) Tickets by SLA Status (Donut/Pie)
-- Q2: Tickets by SLA Status
SELECT
  sla_status,
  COUNT(*) AS total_tickets,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_share
FROM vw_fact_ticket
GROUP BY sla_status
ORDER BY total_tickets DESC;

# Q3) Tickets by Priority (Donut/Pie)
#Tickets by Priority
SELECT
  priority,
  COUNT(*) AS total_tickets,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_share
FROM vw_fact_ticket
GROUP BY priority
ORDER BY total_tickets DESC;

#Q4) Advanced: Closed vs Open Trend by Month (Line chart)
-- Monthly trend (Closed vs Open)
SELECT
  DATE_FORMAT(created_date, '%Y-%m') AS month,
  COUNT(*) AS total_tickets,
  SUM(is_closed_flag) AS closed_tickets,
  SUM(is_open_flag)   AS open_tickets,
  ROUND(AVG(resolution_time_hour), 2) AS avg_resolution_hours
FROM vw_fact_ticket
WHERE created_date IS NOT NULL
GROUP BY DATE_FORMAT(created_date, '%Y-%m')
ORDER BY month;

#(Bonus Advanced) Top Agents by Ticket Volume + SLA Breach Rate
-- Bonus: Top agents + SLA breach rate (advanced)
SELECT
  a.agent_name,
  COUNT(*) AS tickets,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_all,
  ROUND(100 * AVG(CASE WHEN t.sla_status LIKE '%Breach%' THEN 1 ELSE 0 END), 2) AS sla_breach_rate_pct
FROM vw_fact_ticket t
LEFT JOIN dim_agent a ON t.agent_id = a.agent_id
GROUP BY a.agent_name
ORDER BY tickets DESC
LIMIT 10;

#Dashboard 2: Resolution & SLA Analysis (4–5 queries)

#1) Avg Resolution Days + Avg Resolution Hours (Basic)
SELECT
  ROUND(AVG(resolution_days), 2) AS avg_resolution_days,
  ROUND(AVG(resolution_time_hour), 2) AS avg_resolution_hours
FROM vw_fact_ticket
WHERE resolution_days IS NOT NULL
  AND resolution_time_hour IS NOT NULL;

#Q2) SLA Met % , SLA Breached % , SLA Met Tickets (Basic → KPI cards)
SELECT
  ROUND(SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_met_pct,
  ROUND(SUM(CASE WHEN sla_status = 'SLA Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breached_pct,
  SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) AS sla_met_tickets
FROM vw_fact_ticket
WHERE sla_status IS NOT NULL;

#Q3) SLA Compliance Trend by Month (Advanced – line chart)
SELECT
  DATE_FORMAT(created_date, '%Y-%m') AS ym,
  COUNT(*) AS total_tickets,
  SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) AS sla_met_tickets,
  ROUND(100 * SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_met_pct
FROM vw_fact_ticket
WHERE created_date IS NOT NULL
GROUP BY ym
ORDER BY ym;

#Q4) Resolution Time Bucket Analysis (Advanced – bucket bar chart)
SELECT
  resolution_bucket,
  COUNT(*) AS tickets,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_share,
  ROUND(AVG(resolution_time_hour), 2) AS avg_hours_in_bucket
FROM vw_fact_ticket
WHERE resolution_bucket IS NOT NULL
GROUP BY resolution_bucket
ORDER BY tickets DESC;

#Q5) (Extra Advanced) Worst Departments by SLA Breach Rate + Avg Hours (Ranked)
SELECT
  d.department_name,
  COUNT(*) AS tickets,
  SUM(CASE WHEN f.sla_status = 'SLA Breached' THEN 1 ELSE 0 END) AS breached_tickets,
  ROUND(100 * SUM(CASE WHEN f.sla_status = 'SLA Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS breached_pct,
  ROUND(AVG(f.resolution_time_hour), 2) AS avg_resolution_hours
FROM vw_fact_ticket f
JOIN dim_department d ON d.department_id = f.department_id
WHERE f.department_id IS NOT NULL
GROUP BY d.department_name
HAVING COUNT(*) >= 50          -- noise remove (optional)
ORDER BY breached_pct DESC, avg_resolution_hours DESC
LIMIT 10;

#Dashboard 3: Agent Performance & Productivity (4–5 queries, basic → advanced)
#Q1) Top 10 agents by ticket volume (Bar)
SELECT
  a.agent_name,
  COUNT(*) AS tickets
FROM fact_ticket f
JOIN dim_agent a ON f.agent_id = a.agent_id
WHERE f.agent_id IS NOT NULL
GROUP BY a.agent_name
ORDER BY tickets DESC
LIMIT 10;
#Q2) SLA Met % by Agent (Bar)
SELECT
  a.agent_name,
  COUNT(*) AS total_tickets,
  ROUND(100 * SUM(CASE WHEN f.sla_status='SLA Met' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_met_pct
FROM fact_ticket f
JOIN dim_agent a ON f.agent_id = a.agent_id
WHERE f.sla_status IS NOT NULL
GROUP BY a.agent_name
HAVING COUNT(*) >= 20
ORDER BY sla_met_pct DESC;
#Q3) Average Resolution Days by Agent (Bar)
SELECT
  a.agent_name,
  ROUND(AVG(f.resolution_days), 2) AS avg_resolution_days,
  COUNT(*) AS tickets
FROM fact_ticket f
JOIN dim_agent a ON f.agent_id = a.agent_id
WHERE f.resolution_days IS NOT NULL
GROUP BY a.agent_name
HAVING COUNT(*) >= 20
ORDER BY avg_resolution_days ASC;

#Q4)Tickets Distribution by Priority (Treemap)
SELECT
  priority,
  COUNT(*) AS tickets
FROM vw_fact_ticket
GROUP BY priority
ORDER BY tickets DESC;


#Q5)Agent Activity Heatmap (Agent x Priority) ✅ (Advanced)
SELECT
  a.agent_name,
  SUM(CASE WHEN f.priority='Critical' THEN 1 ELSE 0 END) AS critical_cnt,
  SUM(CASE WHEN f.priority='High' THEN 1 ELSE 0 END)     AS high_cnt,
  SUM(CASE WHEN f.priority='Medium' THEN 1 ELSE 0 END)   AS medium_cnt,
  SUM(CASE WHEN f.priority='Low' THEN 1 ELSE 0 END)      AS low_cnt,
  SUM(CASE WHEN f.priority IS NULL OR f.priority='' OR f.priority='Not Assigned' THEN 1 ELSE 0 END) AS not_assigned_cnt,
  COUNT(*) AS total
FROM vw_fact_ticket f
JOIN dim_agent a ON a.agent_id = f.agent_id
GROUP BY a.agent_name
ORDER BY total DESC;

#Dashboard 4: Customer & CSAT Insights (4–5 queries)
#Q1 (Basic) Avg CSAT (overall)
SELECT
  ROUND(AVG(customer_satisfaction), 2) AS avg_csat
FROM vw_fact_ticket
WHERE customer_satisfaction IS NOT NULL;

#Q2 Inmediate) CSAT by SLA Status
SELECT
  sla_status,
  COUNT(*) AS tickets_with_csat,
  ROUND(AVG(customer_satisfaction), 2) AS avg_csat
FROM vw_fact_ticket
WHERE customer_satisfaction IS NOT NULL
GROUP BY sla_status
ORDER BY avg_csat DESC;

#Q3) Tickets Count by Customer Type (FIXED with JOIN)
SELECT
  c.customer_type,
  COUNT(*) AS tickets
FROM vw_fact_ticket f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY tickets DESC;

#Q4) Total Tickets by CSAT Rating (Pie)
SELECT
  customer_satisfaction,
  COUNT(*) AS tickets
FROM vw_fact_ticket
WHERE customer_satisfaction IS NOT NULL
GROUP BY customer_satisfaction
ORDER BY customer_satisfaction;

#Q5)Top Customers (Tickets + Avg CSAT) (Advanced)
SELECT
  c.customer_name,
  COUNT(*) AS total_tickets,
  ROUND(AVG(f.customer_satisfaction), 2) AS avg_csat
FROM vw_fact_ticket f
JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE f.customer_satisfaction IS NOT NULL
GROUP BY c.customer_name
ORDER BY total_tickets DESC, avg_csat DESC
LIMIT 20;

#Unknown column customer_type
#use this (JOIN):
SELECT c.customer_type, COUNT(*)
FROM vw_fact_ticket f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_type;

#Unknown column customer_name
SELECT c.customer_name, COUNT(*)
FROM vw_fact_ticket f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_name;

#Unknown column created_dt
SELECT DATE_FORMAT(created_date, '%Y-%m') AS ym, COUNT(*)
FROM vw_fact_ticket
GROUP BY ym;

#Dashboard 5: Workload & Capacity Management (5 Queries)
#Q1) Avg Tickets per Agent
SELECT
  ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT agent_id), 2) AS avg_tickets_per_agent
FROM vw_fact_ticket
WHERE agent_id IS NOT NULL;

#Q2) Total Agents + Underutilized + Overloaded (Basic segmentation by ticket volume)
WITH a AS (
  SELECT agent_id, COUNT(*) AS tickets
  FROM vw_fact_ticket
  WHERE agent_id IS NOT NULL
  GROUP BY agent_id
)
SELECT
  COUNT(*) AS total_agents,
  SUM(CASE WHEN tickets < 20 THEN 1 ELSE 0 END) AS underutilized_agents,
  SUM(CASE WHEN tickets > 60 THEN 1 ELSE 0 END) AS overloaded_agents
FROM a;
#Q3) Capacity Segmentation (Balanced/Overloaded/Underutilized) ✅
WITH a AS (
  SELECT agent_id, COUNT(*) AS tickets
  FROM vw_fact_ticket
  WHERE agent_id IS NOT NULL
  GROUP BY agent_id
),
seg AS (
  SELECT
    CASE
      WHEN tickets < 20 THEN 'Underutilized'
      WHEN tickets > 60 THEN 'Overloaded'
      ELSE 'Balanced'
    END AS capacity_category
  FROM a
)
SELECT capacity_category, COUNT(*) AS agents
FROM seg
GROUP BY capacity_category;


#Q4) Workload Trend Over Time (Month-wise total tickets)
SELECT
  DATE_FORMAT(created_date, '%Y-%m') AS ym,
  COUNT(*) AS total_tickets
FROM vw_fact_ticket
WHERE created_date IS NOT NULL
GROUP BY ym
ORDER BY ym;

#Q5) Workload vs Resolution Efficiency (Scatter base)
SELECT 
    agent_id,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_days), 2) AS avg_resolution_days
FROM vw_fact_ticket
WHERE agent_id IS NOT NULL
GROUP BY agent_id;











