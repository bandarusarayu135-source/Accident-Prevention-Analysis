-- Road Accident Analysis using SQL
-- Tool Used: MySQL
-- Dataset: Indian Road Accident Dataset

Create database accidents_db;
Use accidents_db;

CREATE TABLE indian_roads (
    accident_id INT Primary Key,
    city VARCHAR(100),
    state VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    date DATE,
    time TIME,
    hour INT,
    day_of_week VARCHAR(20),
    is_weekend BOOLEAN,
    road_type VARCHAR(50),
    lanes INT,
    traffic_signal VARCHAR(10),
    weather VARCHAR(50),
    visibility VARCHAR(50),
    temperature FLOAT,
    traffic_density VARCHAR(50),
    cause VARCHAR(100),
    accident_severity VARCHAR(20),
    vehicles_involved INT,
    casualties INT,
    is_peak_hour BOOLEAN,
    festival VARCHAR(100),
    risk_score FLOAT
);

-- 1.Step-1:Understanding the data
Select * from indian_roads Limit 10;

Select Count(*) As total_count from indian_roads;
-- total_records=20000
Select Count(Distinct city) AS total_cities From indian_roads;
-- total_cities=8

-- Step-2: Data Quality Check
-- 1.Check NULL values
Select 
    Count(*) As total_rows,
    Count(city) AS city_not_null,
    Count(weather) As weather_not_null,
    Count(accident_severity) As severity_not_null
from indian_roads;

-- 2.Check Duplicate values
Select accident_id, COUNT(*)
from indian_roads
Group by accident_id
Having Count(*)>1;
-- Insight:There are no null and duplicate values 

-- Step-3: Accident Distribution Analysis
-- 1) Where accidents happening most?
-- 1.Accidents by city
Select city, Count(*) As total_accidents
from indian_roads
Group by city
Order By total_accidents Desc;

-- 2.Accidents by state
Select state, Count(*) As total_accidents
From indian_roads
Group by state
Order By total_accidents Desc;

-- 3.Top-5 accident prone cities
Select city, Count(*) AS total
from indian_roads
Group by city
Order by total DESC
Limit 5;
-- Insight:
-- Accidents are fairly evenly distributed across cities,
-- with Chandigarh showing slightly higher accident counts.
-- Total no.of accidents are more in Maharashtra compare to other states

-- Step-4: Time-based Analysis
-- 2) When accidents happen?
-- 1.Accidents by time-period
SELECT 
    CASE 
        WHEN hour BETWEEN 0 AND 5 THEN 'Night'
        WHEN hour BETWEEN 6 AND 11 THEN 'Morning'
        WHEN hour BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    COUNT(*) AS total
FROM indian_roads
GROUP BY time_period;

-- 2.Peak vs non-peak hour
Select is_peak_hour, Count(*) As total
From indian_roads
Group by is_peak_hour;

-- 3. Accidents by day of week
Select day_of_week, Count(*) As total
from indian_roads
Group by day_of_week
Order by total desc;
-- Insight:
-- Accidents are fairly evenly distributed across all time periods, with a slight increase during night and afternoon hours.
-- More accidents occur during non-peak hours compared to peak hours.
-- Accidents are almost evenly distributed across all days, with a slight increase on Mondays.

-- Step-5: Environmental Analysis
-- 3) Why accidents happen?
-- 1.Weather +severity
SELECT weather, accident_severity, COUNT(*) AS total
FROM indian_roads
GROUP BY weather, accident_severity
ORDER BY total DESC;

-- 2.Visibility +Severity
SELECT visibility, accident_severity, COUNT(*) AS total
FROM indian_roads
GROUP BY visibility, accident_severity
ORDER BY total DESC;
-- Insights:
-- Accidents occur across all weather conditions,
-- while rain and fog show slightly higher severity levels.
-- Adverse conditions like rain, fog, and low visibility contribute to higher accident severity and risk

-- Step-6: Road & traffic analysis
-- 4) WHY accidents happen (infrastructure side)
-- 1.Road type + severity
SELECT road_type, accident_severity, COUNT(*) AS total
FROM indian_roads
GROUP BY road_type, accident_severity
ORDER BY total DESC;

-- 2.Traffic density +severity
SELECT traffic_density, accident_severity, COUNT(*) AS total
FROM indian_roads
GROUP BY traffic_density, accident_severity
ORDER BY total DESC;
-- Insights:
-- Urban roads show slightly higher accident frequency,
-- likely due to increased traffic density.
-- Both low and high traffic conditions show similar accident counts, indicating that accidents are not heavily dependent on traffic density alone.

-- Step-6.5: Vehicle Involvement Analysis
-- 5) Number of vehicles involved?
-- 1.Average vehicles involved by severity
SELECT accident_severity,
       AVG(vehicles_involved) AS avg_vehicles
FROM indian_roads
GROUP BY accident_severity;

-- 2.Vehicles involved distribution
SELECT vehicles_involved, COUNT(*) AS total_accidents
FROM indian_roads
GROUP BY vehicles_involved
ORDER BY vehicles_involved;
-- Insights:
-- Most accidents involve a limited number of vehicles,
-- while severe accidents tend to show slightly higher
-- vehicle involvement.

-- Step-7 : Top Risk Analysis
-- 1. Top cities with most accidents
SELECT city, COUNT(*) AS total,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_city
FROM indian_roads
GROUP BY city
Order by rank_city;

-- 2.Top risk combination
SELECT weather, visibility, road_type, COUNT(*) AS total
FROM indian_roads
GROUP BY weather, visibility, road_type
ORDER BY total DESC
LIMIT 5;

-- 3.Percentage analysis
SELECT weather,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM indian_roads) AS percentage
FROM indian_roads
GROUP BY weather
Order by percentage DESC;
-- Insights:
-- Chandigarh ranks highest in accident count, followed by other cities with only minor differences
-- Most accidents happen in clear conditions, but fog with low visibility is a major risk factor.
 
-- Step-7.5: Cause Analysis
-- 6) What are the main cause of accidents?
-- 1.Most common accident causes
SELECT cause, COUNT(*) AS total_accidents
FROM indian_roads
GROUP BY cause
ORDER BY total_accidents DESC;

-- 2.Cause + Severity
SELECT cause, accident_severity, COUNT(*) AS total
FROM indian_roads
GROUP BY cause, accident_severity
ORDER BY total DESC;

-- 3.Top Fatal causes
SELECT cause, COUNT(*) AS fatal_accidents
FROM indian_roads
WHERE accident_severity = 'fatal'
GROUP BY cause
ORDER BY fatal_accidents DESC;
-- Insights:
-- The major causes of accidents are distracted driving and overspeeding.
-- Fatal accidents are mainly associated with poor road conditions and drunk driving.

-- =========================================
-- Step 8: Final Summary & Prevention Strategies
-- =========================================

-- Final Summary:
-- This project analyzed accident patterns using SQL
-- across weather, traffic, visibility, road conditions,
-- and accident causes.

-- Key Findings:
-- 1. Urban areas showed slightly higher accident frequency.
-- 2. Low visibility and fog contributed to severe accidents.
-- 3. Driver-related causes significantly influenced accidents.

-- Prevention Strategies:
-- 1. Improve road visibility and lighting systems.
-- 2. Implement stricter speed monitoring.
-- 3. Increase awareness about distracted driving.
-- 4. Use smart traffic management systems.



