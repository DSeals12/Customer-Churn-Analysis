--How many total customers are in the dataset?
SELECT
	COUNT(customerID) AS Total_Customers
FROM dbo.Customer_Churn

--How many unique customers do we have?
SELECT
	COUNT(DISTINCT(customerID)) AS Unique_Customers
FROM dbo.Customer_Churn

--What is the overall churn rate in our customer base?
-- Approach 1: Let's verify the exact string matching
SELECT 
    churn,
    COUNT(*) as count,
    ASCII(LEFT(churn,1)) as first_char_ascii,
    LEN(churn) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY churn;

-- Approach 2: Using LIKE instead of exact matching
SELECT 
    COUNT(*) as total_customers,
    SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM customer_churn;

--Are there any duplicate customer records?
SELECT
	customerID
FROM dbo.Customer_Churn
GROUP By customerID
HAVING COUNT(*) > 1

--What are all the possible values in each categorical column?
SELECT
	COUNT(*),
	COUNT(DISTINCT(gender)),
	COUNT(SeniorCitizen),
	COUNT(customerID)
FROM dbo.Customer_Churn
