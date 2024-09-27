-- Exploratory Data Analysis --

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

WITH Rolling_total AS
(
SELECT substring(`DATE`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`DATE`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`, total_off, SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_ranking AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS rank_year
FROM Company_year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_ranking
WHERE rank_year <= 5;
