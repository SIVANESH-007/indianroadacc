create database acc_proj;
CREATE TABLE traffic_accidents (
    accident_id INT,
    city VARCHAR(100),
    state VARCHAR(100),
    accident_date DATE,
    accident_time TIME,
    accident_hour INT,
    day_of_week VARCHAR(20),
    weather VARCHAR(50),
    cause VARCHAR(100),
    accident_severity VARCHAR(20),
    casualties INT,
    risk_score DECIMAL(5,2)
);

alter table traffic_accidents
drop column accident_hour ;

show tables;

select count(*) as total_accidents from traffic_accidents;

select * from traffic_accidents limit 10 ;


select * from traffic_accidents where city is null;

select * from traffic_accidents where state is null or 
								accident_date is null or
                                accident_hour is null or 
                                weather is null or
                                cause is null or 
                                accident_severity is null;

describe traffic_accidents;

select accident_id, count(*) as duplicate_count from traffic_accidents
	group by accident_id 
    having count(*)>1;
    
select cause, count(*) as total_accidents from traffic_accidents
	group by cause;
    
select min(accident_date) as earliest_accident, 
		max(accident_date) as latest_accident
			from traffic_accidents;
            
SELECT
    MIN(casualties) AS min_casualties,
    MAX(casualties) AS max_casualties,
    AVG(casualties) AS avg_casualties,
    MIN(risk_score) AS min_risk_score,
    MAX(risk_score) AS max_risk_score,
    AVG(risk_score) AS avg_risk_score
FROM traffic_accidents;


## ACCIDENT BY STATE

SELECT STATE , count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by STATE;
            
# ACCIDENT BY CITY

SELECT CITY , count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by CITY;
            
##ACCIDENT BY SEVERITY

SELECT accident_severity , count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by accident_severity
            order by TOTAL_ACCIDENT DESC;

## ACCIDENT BY MONTH

select month(ACCIDENT_DATE),monthname(ACCIDENT_DATE),
				count(*) AS TOTAL_ACCIDENTS
                FROM traffic_accidents
                group by monthname(ACCIDENT_DATE),month(ACCIDENT_DATE)
                order by month(ACCIDENT_DATE);

## ACCIDENT BY YEAR

SELECT year(ACCIDENT_DATE)  AS YEAR, count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by YEAR(ACCIDENT_DATE)
            order by YEAR(ACCIDENT_DATE);
            
### ACCIDENT BY DAY OF WEEK
SELECT day_of_week , count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by day_of_week
            order by TOTAL_ACCIDENT DESC;
            
            
## ACCIDENT BY WEATHER

SELECT accident_hour, count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by accident_hour
            order by TOTAL_ACCIDENT DESC;
            
            
## ACCIDENT BY WEATHER

SELECT WEATHER, count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by weather
            order by TOTAL_ACCIDENT DESC;
            
            
## ACCIDENT BY WEATHER

SELECT WEATHER,accident_severity, count(*) AS TOTAL_ACCIDENT
			FROM traffic_accidents
            group by weather,accident_severity
            order by accident_severity DESC;
            
select * FROM traffic_accidents;

## TOTAL CAUSALITIES BY STATE 

select STATE,SUM(casualties) AS TOTAL_CASUALITIES
		FROM traffic_accidents
        group by state
        order by TOTAL_CASUALITIES DESC;
        
## TOTAL CAUSALITIES BY CITY 

select CITY,SUM(casualties) AS TOTAL_CASUALITIES
		FROM traffic_accidents
        group by CITY
		order by TOTAL_CASUALITIES DESC;
	
    
## PERCENTAGE OF ACCIDENT BY STATE

select STATE,count(*) AS TOTAL_ACCIDENT,
	concat(ROUND(COUNT(*) * 100/(SELECT COUNT(*) FROM traffic_accidents),2),"%") AS PERCENT
			FROM traffic_accidents
            group by state;
            
## HIGHEST RISK ACCIDENT OF EACH STATE

select * FROM 
(select STATE,CITY,ACCIDENT_ID,ACCIDENT_SEVERITY,CASUALTIES,RISK_SCORE
			,RANK()OVER(partition by STATE
            order by RISK_SCORE DESC ) AS RISK_RANK FROM traffic_accidents)
            AS RANKED_ACCIDENTS WHERE RISK_RANK =1;
            
## ACCIDENT LAG BY YEAR

WITH A AS(select year(ACCIDENT_DATE) AS ACCIDENT_YEAR,count(*) AS TOTAL_ACCIDENTS,
		LAG(count(*)) OVER(order by year(ACCIDENT_DATE))AS PREV_YEAR
        FROM traffic_accidents
        group by year(ACCIDENT_DATE))
        select ACCIDENT_YEAR,TOTAL_ACCIDENTS,PREV_YEAR,
        TOTAL_ACCIDENTS-PREV_YEAR AS ACC_RATE FROM A;
        
        
SELECT
    state,
    COUNT(*) AS total_accidents,
    SUM(casualties) AS total_casualties,
    ROUND(AVG(risk_score), 2) AS avg_risk_score,
    SUM(CASE
        WHEN accident_severity = 'Fatal' THEN 1
        ELSE 0
    END) AS fatal_accidents
FROM traffic_accidents
GROUP BY state
ORDER BY total_accidents DESC;