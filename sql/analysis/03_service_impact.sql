--Do customers with tech support stay longer?
SELECT
	TechSupport,
	AVG(tenure) AS Avg_Tenure,
	COUNT(*) AS Count_
FROM Customer_Churn
GROUP BY TechSupport

--OR

SELECT
	CASE WHEN TechSupport LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Tech_Support,
	AVG(tenure) AS Avg_Tenure,
	COUNT(*) AS Count_
FROM Customer_Churn
GROUP BY 
	CASE WHEN TechSupport LIKE '%Yes%' Then 'Yes' ELSE 'No' END

--Do customers with online security churn less?
SELECT
	CASE WHEN OnlineSecurity LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Online_Security,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage,
	COUNT(*) AS Count_
FROM Customer_Churn
GROUP BY 
	CASE WHEN OnlineSecurity LIKE '%Yes%' Then 'Yes' ELSE 'No' END

--Which additional services seem to reduce churn rate the most?
SELECT
	CASE WHEN OnlineSecurity LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Online_Security,
	CASE WHEN OnlineBackup LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Online_Backup,
	CASE WHEN PaperlessBilling LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Paperless_Billing,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage,
	COUNT(*) AS Count_
FROM Customer_Churn
GROUP BY 
	CASE WHEN OnlineSecurity LIKE '%Yes%' Then 'Yes' ELSE 'No' END,
	CASE WHEN OnlineBackup LIKE '%Yes%' Then 'Yes' ELSE 'No' END,
	CASE WHEN PaperlessBilling LIKE '%Yes%' Then 'Yes' ELSE 'No' END

SELECT
	SUM(CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END) as with_security,
    SUM(CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END) as with_backup,
    SUM(CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END) as with_protection,
    SUM(CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END) as with_support,
    SUM(CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END) as with_tv,
    SUM(CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) as with_movies,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage,
	COUNT(*) AS Count_
FROM Customer_Churn
WHERE churn LIKE '%Yes%'

--Is there a relationship between multiple services and customer tenure?
-- 1. Calculate average tenure based on number of additional services
WITH ServiceCount AS (
    SELECT 
        customerID,
        tenure,
        (CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) as number_of_services
    FROM customer_churn
)
SELECT 
    number_of_services,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
    CAST(MIN(tenure) AS DECIMAL(10,2)) as min_tenure,
    CAST(MAX(tenure) AS DECIMAL(10,2)) as max_tenure,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_of_customers
FROM ServiceCount
GROUP BY number_of_services
ORDER BY number_of_services;

-- 2. Analyze tenure patterns for specific service combinations
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 36 THEN '25-36 months'
        ELSE 'Over 36 months'
    END as tenure_group,
    COUNT(*) as customer_count,
    SUM(CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as security_adoption_rate,
    SUM(CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as backup_adoption_rate,
    SUM(CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as protection_adoption_rate,
    SUM(CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as tech_support_adoption_rate,
    SUM(CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as streaming_tv_adoption_rate,
    SUM(CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as streaming_movies_adoption_rate
FROM customer_churn
GROUP BY 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 36 THEN '25-36 months'
        ELSE 'Over 36 months'
    END
;

-- 3. Analyze churn rate based on service combinations and tenure
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 36 THEN '25-36 months'
        ELSE 'Over 36 months'
    END as tenure_group,
    number_of_services,
    COUNT(*) as customer_count,
    SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as churn_rate
FROM (
    SELECT 
        *,
        (CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END +
         CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) as number_of_services
    FROM customer_churn
) service_data
GROUP BY 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 36 THEN '25-36 months'
        ELSE 'Over 36 months'
    END,
    number_of_services

--Do customers with paperless billing churn more or less?
SELECT
	CASE WHEN PaperlessBilling LIKE '%Yes%' Then 'Yes' ELSE 'No' END AS Paperless_Billing,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage,
	COUNT(*) AS Count_
FROM Customer_Churn
GROUP BY 
	CASE WHEN PaperlessBilling LIKE '%Yes%' Then 'Yes' ELSE 'No' END

