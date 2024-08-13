create database siproject;
use siproject;

select * from layoffs;
SELECT COUNT(*) FROM layoffs;
SELECT distinct COUNT(*) FROM layoffs;

SELECT * FROM LAYOFFS WHERE COMPANY = 'Oda';



SELECT DISTINCT INDUSTRY FROM layoffs ORDER BY 1;

-- TODO: UPDATE THESE VALUES TO STANDARD VALUE
SELECT * FROM layoffs WHERE INDUSTRY LIKE 'Crypto%';
-- DONE: UPDATE THESE VALUES TO travel
SELECT * FROM layoffs WHERE COMPANY LIKE '%airbnb%';


SELECT *
FROM layoffs
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SET SQL_SAFE_UPDATES = 0;





UPDATE layoffs
SET INDUSTRY = NULL
WHERE INDUSTRY = '';



SELECT *
FROM layoffs
WHERE industry IS NULL
ORDER BY industry;


SELECT T1.COMPANY, T1.INDUSTRY, T2.INDUSTRY
FROM layoffs AS T1
JOIN LAYOFFS AS T2
	ON T1.COMPANY = T2.COMPANY
WHERE T1.INDUSTRY IS NULL
AND T2.INDUSTRY IS NOT NULL;


UPDATE layoffs AS T1
JOIN LAYOFFS T2
	ON T1.COMPANY = T2.COMPANY
SET T1.INDUSTRY = T2.INDUSTRY
WHERE T1.INDUSTRY IS NULL
AND T2.INDUSTRY IS NOT NULL;

SELECT DISTINCT INDUSTRY FROM layoffs WHERE INDUSTRY LIKE 'Crypto%';

UPDATE layoffs
SET INDUSTRY = 'Crypto'
WHERE INDUSTRY LIKE 'Crypto%';
-- ANOTHER WAY: WHERE industry IN ('Crypto Currency', 'CryptoCurrency')

SELECT * FROM layoffs;


SELECT DISTINCT COUNTRY FROM layoffs ORDER BY 1;


UPDATE layoffs
SET COUNTRY = TRIM(TRAILING '.' FROM COUNTRY);

SELECT `DATE`, str_to_date(`DATE`, '%m/%d/%Y')
from layoffs;

UPDATE layoffs
SET `DATE` = str_to_date(`DATE`, '%m/%d/%Y');

ALTER TABLE layoffs
MODIFY COLUMN `DATE` DATE;

SELECT * 
FROM layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT MAX(TOTAL_LAID_OFF) FROM layoffs;

SELECT * 
FROM layoffs
WHERE funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC;       

SELECT distinct COMPANY, funds_raised_millions 
FROM layoffs
WHERE funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC;   

SELECT LOCATION, SUM(total_laid_off) AS SUM_LAID
FROM layoffs
GROUP BY LOCATION
ORDER BY SUM_LAID DESC
LIMIT 10;              

SELECT MAX(total_laid_off)
FROM LAYOFFS;

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM LAYOFFS
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM LAYOFFS
WHERE  percentage_laid_off = 1 and total_laid_off is not null;
-- these are mostly startups it looks like who all went out of business during this time


-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM LAYOFFS
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs
ORDER BY 2 DESC
LIMIT 5;
-- now that's just on a single day

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- this it total in the past 3 years or in the dataset

SELECT country, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM LAYOFFS
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT industry, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY stage
ORDER BY 2 DESC;

-- TOUGHER QUERIES

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at 

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM LAYOFFS
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM LAYOFFS
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM LAYOFFS
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;











    






