--What percentage of customers have phone service?
SELECT 
    PhoneService,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY PhoneService;

--What percentage of customers have internet service?
SELECT 
    CASE WHEN InternetService LIKE '%No%' THEN 'No' ELSE 'Yes' END AS Internet_Options,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY 
	 CASE 
        WHEN InternetService LIKE '%No%' THEN 'No'
        ELSE 'Yes'
END;

--What's the distribution of internet service types (DSL, Fiber Optic, etc.)?
SELECT 
    InternetService,
    COUNT(*) as count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY InternetService;

--Which internet service type has the highest churn rate?
SELECT 
	InternetService,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percentage DESC;

--What percentage of customers have both phone and internet services?
SELECT 
    InternetService,
	PhoneService,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
WHERE PhoneService LIKE '%Yes%'
AND InternetService NOT LIKE '%No%'
GROUP BY InternetService, PhoneService;

--How many customers use each type of contract?
SELECT
	COUNT(*) AS Count_,
	Contract_
FROM Customer_Churn
GROUP BY Contract_

--Which contract type has the lowest churn rate?
SELECT 
	Top 1
	Contract_,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM customer_churn
GROUP BY Contract_
ORDER BY churn_rate_percentage ASC;



