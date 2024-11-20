--How does the churn rate vary with tenure?
-- Subquery
SELECT
	COUNT_,
	Tenure_,
	churn_rate_percentage
FROM 
(
	SELECT 
	COUNT(*) AS COUNT_,
	CASE WHEN tenure >= 40 THEN 1 ELSE 2 END AS Tenure_,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage	
	FROM Customer_Churn
    GROUP BY CASE WHEN tenure >= 40 THEN 1 ELSE 2 END
) AS Churn_Analysis
ORDER BY Tenure_

--CTE
WITH ChurnAnalysis AS (
    SELECT 
        CASE WHEN tenure >= 40 THEN 1 ELSE 2 END AS Tenure_,
        CAST(
            (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
            CAST(COUNT(*) AS FLOAT)) * 100 
        AS DECIMAL(10,2)) as churn_rate_percentage,
        COUNT(*) AS COUNT_
    FROM Customer_Churn
    GROUP BY 
        CASE WHEN tenure >= 40 THEN 1 ELSE 2 END
)
SELECT 
    Tenure_,
    COUNT_,
    churn_rate_percentage
FROM ChurnAnalysis
ORDER BY Tenure_;


--What's the average tenure for each contract type?
SELECT
	AVG(tenure) AS AVG_Tenure,
	Contract_
FROM Customer_Churn
GROUP BY Contract_

--At what tenure points do we see the highest churn rates?
SELECT
	tenure,
--	RANK() OVER(ORDER BY tenure DESC) AS Rank_,
	COUNT(*) AS COUNT_,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM Customer_Churn
GROUP BY tenure
ORDER BY churn_rate_percentage DESC

--How do monthly charges vary with tenure?
SELECT
	AVG_Monthly_Charges,
	Tenure_
FROM
(
	SELECT
	CAST(AVG(MonthlyCharges)AS INT) AS AVG_Monthly_Charges,
	CASE WHEN tenure >= 40 THEN 1 ELSE 2 END AS Tenure_
	FROM Customer_Churn
	GROUP BY CASE WHEN tenure >= 40 THEN 1 ELSE 2 END 
) AS Monthly_Charges_Tenure
ORDER BY AVG_Monthly_Charges DESC

--What's the relationship between tenure and total charges?
SELECT
	AVG_Total_Charges,
	Tenure_
FROM
(
	SELECT
	CAST(AVG(TotalCharges)AS INT) AS AVG_Total_Charges,
	CASE WHEN tenure >= 60 THEN 1 ELSE 2 END AS Tenure_
	FROM Customer_Churn
	GROUP BY CASE WHEN tenure >= 60 THEN 1 ELSE 2 END 
) AS Monthly_Charges_Tenure
ORDER BY AVG_Total_Charges DESC
