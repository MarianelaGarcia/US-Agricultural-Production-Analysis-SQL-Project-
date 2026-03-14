-- =====================================================
-- USDA Agricultural Production Analysis
-- Business Questions for Strategic Planning
-- =====================================================

-- -----------------------------------------------------
-- Question 1
-- Business Need:
-- Determine the total milk production for the year 2023
-- for the USDA annual production report.
-- -----------------------------------------------------

SELECT SUM(Value) AS total_milk_production_2023
FROM milk_production
WHERE Year = 2023;


-- -----------------------------------------------------
-- Question 2
-- Business Need:
-- Identify states where cheese production exceeded
-- 100 million units in April 2023.
-- This helps the Cheese Department focus marketing
-- efforts in high-production regions.
-- -----------------------------------------------------

SELECT COUNT(DISTINCT State_ANSI) AS states_over_100m_cheese
FROM cheese_production
WHERE Year = 2023
AND Period = 'APR'
AND Value > 100000000;


-- -----------------------------------------------------
-- Question 3
-- Business Need:
-- Analyze coffee production trends over the years
-- and determine the total production value for 2011.
-- -----------------------------------------------------

-- Coffee production trend by year
SELECT Year, SUM(Value) AS total_coffee_production
FROM coffee_production
GROUP BY Year
ORDER BY Year;

-- Total coffee production specifically for 2011
SELECT SUM(Value) AS total_coffee_production_2011
FROM coffee_production
WHERE Year = 2011;


-- -----------------------------------------------------
-- Question 4
-- Business Need:
-- Calculate the average honey production for the year 2022
-- in preparation for the upcoming Honey Council meeting.
-- -----------------------------------------------------

SELECT AVG(Value) AS avg_honey_production_2022
FROM honey_production
WHERE Year = 2022;


-- -----------------------------------------------------
-- Question 5
-- Business Need:
-- Provide a list of all states with their corresponding
-- ANSI codes for the State Relations team.
-- -----------------------------------------------------

-- List all states with their ANSI codes
SELECT State, State_ANSI
FROM state_lookup
ORDER BY State;

-- Retrieve the ANSI code for Florida
SELECT State_ANSI
FROM state_lookup
WHERE State = 'FLORIDA';


-- -----------------------------------------------------
-- Question 6
-- Business Need:
-- Generate a cross-commodity report showing cheese production
-- values for all states in April 2023, including states with
-- zero production. This helps identify underperforming regions.
-- -----------------------------------------------------

-- List all states with their cheese production in April 2023
SELECT s.State, COALESCE(c.Value,0) AS cheese_production_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c 
  ON s.State_ANSI = c.State_ANSI
  AND c.Year = 2023
  AND c.Period = 'APR'
ORDER BY s.State;

-- Calculate the total cheese production for NEW JERSEY
SELECT COALESCE(SUM(c.Value),0) AS total_cheese_new_jersey
FROM state_lookup s
LEFT JOIN cheese_production c 
  ON s.State_ANSI = c.State_ANSI
  AND c.Year = 2023
  AND c.Period = 'APR'
WHERE s.State = 'NEW JERSEY';


-- -----------------------------------------------------
-- Question 7
-- Business Need:
-- Calculate the total yogurt production for the year 2022
-- but only for states that also have cheese production
-- data in 2023. This helps the Dairy Division plan resources.
-- -----------------------------------------------------

SELECT SUM(y.Value) AS total_yogurt_2022
FROM yogurt_production y
WHERE y.Year = 2022
  AND y.State_ANSI IN (
      SELECT DISTINCT State_ANSI
      FROM cheese_production
      WHERE Year = 2023
  );


-- -----------------------------------------------------
-- Question 8
-- Business Need:
-- Identify all states that are missing milk production data
-- for the year 2023. This helps highlight data gaps.
-- -----------------------------------------------------

-- List all states missing from milk_production in 2023
SELECT s.State
FROM state_lookup s
LEFT JOIN milk_production m
  ON s.State_ANSI = m.State_ANSI
  AND m.Year = 2023
WHERE m.State_ANSI IS NULL
ORDER BY s.State;

-- Count of states missing milk production in 2023
SELECT COUNT(*) AS states_missing_milk_2023
FROM state_lookup s
LEFT JOIN milk_production m
  ON s.State_ANSI = m.State_ANSI
  AND m.Year = 2023
WHERE m.State_ANSI IS NULL;


-- -----------------------------------------------------
-- Question 9
-- Business Need:
-- List all states with their cheese production values
-- for April 2023, including states with zero production.
-- Also, check if Delaware produced any cheese in April 2023.
-- -----------------------------------------------------

-- List all states with cheese production values in April 2023
SELECT s.State, COALESCE(c.Value,0) AS cheese_production_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c
  ON s.State_ANSI = c.State_ANSI
  AND c.Year = 2023
  AND c.Period = 'APR'
ORDER BY s.State;

-- Check cheese production specifically for Delaware in April 2023
SELECT COALESCE(SUM(c.Value),0) AS cheese_production_delaware_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c
  ON s.State_ANSI = c.State_ANSI
  AND c.Year = 2023
  AND c.Period = 'APR'
WHERE s.State = 'DELAWARE';


-- -----------------------------------------------------
-- Question 10
-- Business Need:
-- Calculate the average coffee production for all years
-- where honey production exceeded 1 million units.
-- This helps identify years with high honey production
-- and their correlation with coffee production trends.
-- -----------------------------------------------------

SELECT AVG(c.Value) AS avg_coffee_high_honey_years
FROM coffee_production c
WHERE c.Year IN (
    SELECT DISTINCT Year
    FROM honey_production
    WHERE Value > 1000000
);