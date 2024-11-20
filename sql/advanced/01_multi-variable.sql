--How do monthly charges vary across different internet service types?
SELECT
	CAST(AVG(MonthlyCharges)AS decimal (10,2)) AS Avg_Monthly_Charges,
	InternetService
FROM Customer_Churn
GROUP BY InternetService

--What's the churn rate for each combination of contract type and internet service?
SELECT
	InternetService,
	Contract_,
	CAST(AVG(MonthlyCharges)AS decimal (10,2)) AS Avg_Monthly_Charges,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM Customer_Churn
GROUP BY InternetService, Contract_
ORDER BY churn_rate_percentage DESC

--How do average monthly charges vary for different contract types?
SELECT
	CAST(AVG(MonthlyCharges)AS decimal (10,2)) AS Avg_Monthly_Charges,
	Contract_
FROM Customer_Churn
GROUP BY Contract_

--What's the relationship between monthly charges and number of additional services?
SELECT
	CAST(AVG(MonthlyCharges)AS decimal (10,2)) AS Avg_Monthly_Charges,
	PhoneService,
	InternetService
FROM Customer_Churn
GROUP BY PhoneService, InternetService

--Which combination of services has the highest average monthly charges?
SELECT
	RANK() OVER(ORDER BY CAST(AVG(MonthlyCharges) AS decimal (10,2)) DESC) AS Rank_,
	CAST(AVG(MonthlyCharges) AS decimal (10,2)) AS Avg_Monthly_charges,
	PhoneService,
	InternetService
FROM Customer_Churn
GROUP BY PhoneService, InternetService
