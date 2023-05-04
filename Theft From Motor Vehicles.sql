-- Table creation 

CREATE TABLE crime (
  X DECIMAL(18, 15) NULL,
  Y DECIMAL(18, 15) NULL,
  OBJECTID INT NULL,
  EVENT_UNIQUE_ID VARCHAR(20) NULL,
  REPORT_DATE VARCHAR(40) NULL,
  OCC_DATE VARCHAR(40) NULL,
  REPORT_YEAR INT NULL,
  REPORT_MONTH VARCHAR(20) NULL,
  REPORT_DAY INT NULL,
  REPORT_DOY INT NULL,
  REPORT_DOW VARCHAR(20) NULL,
  REPORT_HOUR INT NULL,
  OCC_YEAR INT NULL,
  OCC_MONTH VARCHAR(20) NULL,
  OCC_DAY INT NULL,
  OCC_DOY INT NULL,
  OCC_DOW VARCHAR(20) NULL,
  OCC_HOUR INT NULL,
  DIVISION VARCHAR(10) NULL,
  LOCATION_TYPE VARCHAR(100) NULL,
  PREMISES_TYPE VARCHAR(100) NULL,
  UCR_CODE INT NULL,
  UCR_EXT INT NULL,
  OFFENCE VARCHAR(100) NULL,
  MCI_CATEGORY VARCHAR(100) NULL,
  HOOD_158 VARCHAR(10) NULL,
  NEIGHBOURHOOD_158 VARCHAR(100) NULL,
  HOOD_140 VARCHAR(10) NULL,
  NEIGHBOURHOOD_140 VARCHAR(100) NULL,
  F_NUM_REMOVED INT NULL,
  LONG_WGS84 DECIMAL(18, 15) NULL,
  LAT_WGS84 DECIMAL(18, 15) NULL
);

-- Loading the data while account for blanks in the datasets

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Theft_From_Motor_Vehicle_Open_Data.csv'
INTO TABLE crime
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@X, @Y, @OBJECTID, @EVENT_UNIQUE_ID, @REPORT_DATE, @OCC_DATE, @REPORT_YEAR, @REPORT_MONTH, @REPORT_DAY, @REPORT_DOY, @REPORT_DOW, @REPORT_HOUR, @OCC_YEAR, @OCC_MONTH, @OCC_DAY, @OCC_DOY, @OCC_DOW, @OCC_HOUR, @DIVISION, @LOCATION_TYPE, @PREMISES_TYPE, @UCR_CODE, @UCR_EXT, @OFFENCE, @MCI_CATEGORY, @HOOD_158, @NEIGHBOURHOOD_158, @HOOD_140, @NEIGHBOURHOOD_140, @F_NUM_REMOVED, @LONG_WGS84, @LAT_WGS84)
SET X = NULLIF(@X, ''),
    Y = NULLIF(@Y, ''),
    OBJECTID = NULLIF(@OBJECTID, ''),
    EVENT_UNIQUE_ID = NULLIF(@EVENT_UNIQUE_ID, ''),
    REPORT_DATE = NULLIF(@REPORT_DATE, ''),
    OCC_DATE = NULLIF(@OCC_DATE, ''),
    REPORT_YEAR = NULLIF(@REPORT_YEAR, ''),
    REPORT_MONTH = NULLIF(@REPORT_MONTH, ''),
    REPORT_DAY = NULLIF(@REPORT_DAY, ''),
    REPORT_DOY = NULLIF(@REPORT_DOY, ''),
    REPORT_DOW = NULLIF(@REPORT_DOW, ''),
    REPORT_HOUR = NULLIF(@REPORT_HOUR, ''),
    OCC_YEAR = NULLIF(@OCC_YEAR, ''),
    OCC_MONTH = NULLIF(@OCC_MONTH, ''),
    OCC_DAY = NULLIF(@OCC_DAY, ''),
    OCC_DOY = NULLIF(@OCC_DOY, ''),
    OCC_DOW = NULLIF(@OCC_DOW, ''),
    OCC_HOUR = NULLIF(@OCC_HOUR, ''),
    DIVISION = NULLIF(@DIVISION, ''),
    LOCATION_TYPE = NULLIF(@LOCATION_TYPE, ''),
    PREMISES_TYPE = NULLIF(@PREMISES_TYPE, ''),
    UCR_CODE = NULLIF(@UCR_CODE, ''),
    UCR_EXT = NULLIF(@UCR_EXT, ''),
    OFFENCE = NULLIF(@OFFENCE, ''),
    MCI_CATEGORY = NULLIF(@MCI_CATEGORY, ''),
    HOOD_158 = NULLIF(@HOOD_158, ''),
    NEIGHBOURHOOD_158 = NULLIF(@NEIGHBOURHOOD_158, ''),
    HOOD_140 = NULLIF(@HOOD_140, ''),
    NEIGHBOURHOOD_140 = NULLIF(@NEIGHBOURHOOD_140, ''),
    F_NUM_REMOVED = NULLIF(@F_NUM_REMOVED, ''),
    LONG_WGS84 = NULLIF(@LONG_WGS84, ''),
    LAT_WGS84 = NULLIF(@LAT_WGS84, '');

-- Before cleaning the data I will remove colmuns that are not necessary for my analysis

ALTER TABLE crime 
	DROP COLUMN X,
    DROP COLUMN Y,
    DROP COLUMN UCR_CODE,
    DROP COLUMN UCR_EXT,
    DROP COLUMN F_NUM_REMOVED,
    DROP COLUMN HOOD_140,
    DROP COLUMN NEIGHBOURHOOD_140;

-- Now I will clean REPORT_DATE and OCC_DATE as I only need the date 

ALTER TABLE crime
ADD CONVERTED_REPORT_DATE DATETIME AFTER REPORT_DATE;

UPDATE crime
SET CONVERTED_REPORT_DATE = STR_TO_DATE(REPORT_DATE, '%Y/%m/%d %H:%i:%s+00');

ALTER TABLE crime 
MODIFY COLUMN CONVERTED_REPORT_DATE DATE; 

ALTER TABLE crime
ADD CONVERTED_OCC_DATE DATETIME AFTER OCC_DATE;

UPDATE crime
SET CONVERTED_OCC_DATE = STR_TO_DATE(OCC_DATE, '%Y/%m/%d %H:%i:%s+00');

ALTER TABLE crime 
MODIFY COLUMN CONVERTED_OCC_DATE DATE; 

-- I will check for duplicates using OBJECTID AND EVENT_UNIQUE_ID as those are the identifiers for stolen vehicles 


SELECT OBJECTID, EVENT_UNIQUE_ID, COUNT(*)
FROM crime
GROUP BY OBJECTID, EVENT_UNIQUE_ID
HAVING COUNT(*) > 1;

-- No duplicates were found
-- Will not search for NULL values

SELECT *
FROM crime
WHERE (
  CASE WHEN OBJECTID IS NULL THEN 1 ELSE 0 END +
  CASE WHEN EVENT_UNIQUE_ID IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_DATE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN CONVERTED_REPORT_DATE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_DATE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN CONVERTED_OCC_DATE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_YEAR IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_MONTH IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_DAY IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_DOY IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_DOW IS NULL THEN 1 ELSE 0 END +
  CASE WHEN REPORT_HOUR IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_YEAR IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_MONTH IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_DAY IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_DOY IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_DOW IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OCC_HOUR IS NULL THEN 1 ELSE 0 END +
  CASE WHEN DIVISION IS NULL THEN 1 ELSE 0 END +
  CASE WHEN LOCATION_TYPE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN PREMISES_TYPE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN OFFENCE IS NULL THEN 1 ELSE 0 END +
  CASE WHEN MCI_CATEGORY IS NULL THEN 1 ELSE 0 END +
  CASE WHEN HOOD_158 IS NULL THEN 1 ELSE 0 END +
  CASE WHEN NEIGHBOURHOOD_158 IS NULL THEN 1 ELSE 0 END
) > 0;

-- The null values are for thefts that happen before 2014 which is not necessary for our analyst thus I will remove this from the table

DELETE FROM crime
WHERE OCC_YEAR IS NULL; 

-- While cleaning I also noticed that there were some occurences that were before 2014 which is not part of our analyst so i will delete those rows as well

DELETE FROM crime
WHERE OCC_YEAR < 2014;

-- Now I will delete my REPORT_DATE and OCC_DATE as these have been converted into a new column and this information is not needed anymore

ALTER TABLE crime
DROP COLUMN REPORT_DATE; 
ALTER TABLE crime
DROP COLUMN OCC_DATE; 

-- Data cleaning is now ccomplete. I will now explore this dataset
-- I want to see how many thefts occur each year from 2014 to 2022

SELECT 
	OCC_YEAR,
    COUNT(*) AS thefts_yearly
FROM 
	crime 
GROUP BY OCC_YEAR
ORDER BY OCC_YEAR;
-- From the results I thefts have not increased or decrease over time

-- I also want to see what times these theft occur the most

SELECT 
	OCC_HOUR,
    COUNT(*) AS thefts_hourly
FROM 
	crime 
GROUP BY OCC_HOUR
ORDER BY OCC_HOUR;
-- From the results I can conclude that thefts start to rise as it gets later into the day

-- I also want to see which months thefts from vehicle occur the most 

SELECT 
	OCC_MONTH,
    COUNT(*) AS thefts_monthly
FROM 
	crime 
GROUP BY OCC_MONTH
ORDER BY thefts_monthly;
-- Thefts are generally the same throughout the year

-- I want to see what premise type these thefts occur the most

SELECT 
	PREMISES_TYPE,
	COUNT(*) AS Premise
FROM
	crime
GROUP BY PREMISES_TYPE
ORDER BY Premise ASC; 
-- Most thefts occur outside of peoples homes

-- Lets see the top 10  neighbourhoods that are less prone to theft from vehicle 

SELECT 
	NEIGHBOURHOOD_158,
	COUNT(*) AS safest_neighbourhood
FROM
	crime
GROUP BY NEIGHBOURHOOD_158
ORDER BY safest_neighbourhood
LIMIT 10; 
-- The lowest thefts from 2014 to 2022 was 128 at Beechborouigh-Greenbrook

-- Lets see the top 10  neighbourhoods that are most prone to theft from vehicle 

SELECT 
	NEIGHBOURHOOD_158,
	COUNT(*) AS dangerous_neighbourhood
FROM
	crime
GROUP BY NEIGHBOURHOOD_158
ORDER BY dangerous_neighbourhood DESC
LIMIT 10;
-- West Humber-Clairville has the highest number of thefts which was 3046

-- This concludes my analyst on Thefts From Motor Vehicles in the Toronto area. I have gained a general idea of which places are more prone to theft and which places are the safest.
