--What percentage of customers have online security?
SELECT 
    OnlineSecurity,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY OnlineSecurity

--What percentage of customers have online backup?
SELECT 
    OnlineBackup,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY OnlineBackup

--What percentage of customers have device protection?
SELECT 
    DeviceProtection,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY DeviceProtection

--What percentage of customers have tech support?
SELECT 
    TechSupport,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY TechSupport

--What percentage of customers have streaming TV?
SELECT 
    StreamingTV,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY StreamingTV

--What percentage of customers have streaming movies?
SELECT 
    StreamingMovies,
	AVG(tenure),
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_,
	RANK() OVER(ORDER BY AVG(tenure) DESC) Rank
FROM customer_churn
GROUP BY StreamingMovies

--Which additional service seems to have the strongest correlation with customer retention?
SELECT 
    StreamingMovies,
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection,
	AVG(tenure),
    COUNT(*) as count,
--    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_,
	RANK() OVER(ORDER BY AVG(tenure) DESC) Rank
FROM customer_churn
GROUP BY 
	StreamingMovies, 
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection

--What's the most common combination of additional services?
SELECT 
    StreamingMovies,
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection,
--	AVG(tenure),
    COUNT(*) as count,
--    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_,
	RANK() OVER(ORDER BY COUNT(*) DESC) Rank
FROM customer_churn
GROUP BY 
	StreamingMovies, 
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection

--Do customers with more additional services tend to churn less?
SELECT 
    StreamingMovies,
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection,
--	AVG(tenure),
    COUNT(*) as count,
--    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_,
	SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
--	RANK() OVER(ORDER BY ch DESC) Rank
FROM customer_churn
GROUP BY 
	StreamingMovies, 
	OnlineBackup, 
	OnlineSecurity, 
	StreamingTV, 
	StreamingMovies, 
	TechSupport, 
	DeviceProtection
ORDER BY churn_rate_percentage ASC
