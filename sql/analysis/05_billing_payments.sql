--What's the distribution of monthly charges?
SELECT
	COUNT(*),
	customerID,
	AVG(MonthlyCharges) AS Monthly_Charges,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM Customer_Churn
WHERE MonthlyCharges >= 118
GROUP BY customerID

--What's the average monthly charge for all customers?
SELECT
	AVG(MonthlyCharges) AS Monthly_Charges
FROM Customer_Churn

--How do monthly charges differ between churned and non-churned customers?
SELECT
	churn,
	COUNT(*) AS Count,
	AVG(MonthlyCharges) AS Monthly_Charges,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage,
	SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
	SUM(CASE WHEN churn LIKE '%No%' THEN 2 ELSE 0 END) as non_churned_customers 
FROM Customer_Churn
GROUP BY Churn

--What's the distribution of total charges?
SELECT
	COUNT(*) AS Count,
	Churn,
	CAST(AVG(TotalCharges) AS INT) AS AVG_Total_Charges,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM Customer_Churn
GROUP BY Churn

--What are the most common payment methods?
SELECT
	PaymentMethod,
	COUNT(*) AS Count,
	RANK() OVER(ORDER BY COUNT(*) DESC) AS Rank
FROM Customer_Churn
GROUP BY PaymentMethod

--Which payment method has the highest churn rate?
SELECT
	PaymentMethod,
	COUNT(*) AS Count,
	RANK() OVER(ORDER BY COUNT(*) DESC) AS Rank,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM Customer_Churn
GROUP BY PaymentMethod

--Is there a correlation between payment method and monthly charges?
SELECT
	PaymentMethod,
	CAST(AVG(MonthlyCharges) AS INT) AS AVG_MON_Charges,
	COUNT(*) AS COUNT
FROM Customer_Churn
GROUP BY PaymentMethod

