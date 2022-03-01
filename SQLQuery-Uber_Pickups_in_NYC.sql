--LETS FIND THE TOP PERFORMING FHV COMPANY OF JAN-FEB 2015

SELECT distinct dispatching_base_number,
	   SUM(CAST(trips as int)) AS 'SUM_OF_ACTIVE_DRIVERS'
FROM [Uber Pickups in NYC]..[Uber-Jan-Feb-FOIL]
--GROUP BY FUNCTION FOR DISTINCT
GROUP BY dispatching_base_number
--ORDER BY SUM OF ACTIVE DRIVERS
ORDER BY 2 DESC



--CLEAN THE DATES & TIME OF APR_14 DATA

SELECT *,
LEFT(CONVERT(CHAR(8), Date, 103), 10) AS CLEAN_DATE,
SUBSTRING(CONVERT(CHAR(23), Time, 25), 12, 5) AS CLEAN_TIME
FROM [Uber Pickups in NYC]..[uber-data-apr14]



ALTER TABLE [Uber Pickups in NYC]..[uber-data-apr14]
Add CLEAN_DATE CHAR(8)

Update [Uber Pickups in NYC]..[uber-data-apr14]
SET CLEAN_DATE = LEFT(CONVERT(CHAR(8), Date, 103), 10)



ALTER TABLE [Uber Pickups in NYC]..[uber-data-apr14]
Add CLEAN_TIME CHAR(5)

Update [Uber Pickups in NYC]..[uber-data-apr14]
SET CLEAN_TIME = SUBSTRING(CONVERT(CHAR(23), Time, 25), 12, 5)



ALTER TABLE [Uber Pickups in NYC]..[uber-data-apr14]
DROP COLUMN Date

ALTER TABLE [Uber Pickups in NYC]..[uber-data-apr14]
DROP COLUMN Time



--DELETE DUPLICATES UBER_RAW_DATA IN APRIL 2014

WITH CTE as (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY CLEAN_DATE, 
			CLEAN_TIME, 
			BASE, 
			LAT, 
			LON 
			ORDER BY CLEAN_DATE, CLEAN_TIME, BASE) AS ROWNUB
FROM [Uber Pickups in NYC]..[uber-data-apr14]
	)
SELECT *
FROM CTE
WHERE ROWNUB > 1



--EXPLORE NEWLY CLEANED DATA (UBER APRIL 2014 DATA)

SELECT Base,
	COUNT(*) AS Total_Trips
FROM [Uber Pickups in NYC]..[uber-data-apr14]
GROUP BY Base
ORDER  BY COUNT(*) DESC


SELECT CLEAN_DATE,
	COUNT(*)
FROM [Uber Pickups in NYC]..[uber-data-apr14]
GROUP BY CLEAN_DATE
ORDER BY COUNT(*) DESC


SELECT COUNT(*) AS 'COUNT',
	TIMETABLE
FROM (
SELECT CLEAN_TIME,
	CASE WHEN CLEAN_TIME >= '06:00' AND CLEAN_TIME < '12:00' THEN 'MORNING' 
		 WHEN CLEAN_TIME >= '12:00' AND CLEAN_TIME < '18:00' THEN 'AFTERNOON'
		 WHEN CLEAN_TIME >= '18:00' AND CLEAN_TIME < '24:00' THEN 'EVENING'
		 ELSE 'NIGHT' END AS TIMETABLE
FROM [Uber Pickups in NYC]..[uber-data-apr14]
) SUB
GROUP BY TIMETABLE
ORDER BY 'COUNT' DESC


