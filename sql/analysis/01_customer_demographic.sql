--What is the gender distribution of our customers?
SELECT 
    gender,
    COUNT(*) as count,
    ASCII(LEFT(gender,1)) as first_char_ascii,
    LEN(gender) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY gender;

--How many senior citizens do we have in our customer base?
SELECT
	COUNT(*) AS Count,
	CASE WHEN SeniorCitizen = 0 THEN 'Not a Senior Citizen'
	WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
	END AS Age_Classification
FROM Customer_Churn
GROUP BY SeniorCitizen

--What's the distribution of customers with dependents?
SELECT 
    Dependents,
    COUNT(*) as count,
    ASCII(LEFT(Dependents,1)) as first_char_ascii,
    LEN(Dependents) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY Dependents;

--What percentage of our customers are married (have partners)?
SELECT 
    Partner_,
    COUNT(*) as count,
    ASCII(LEFT(Partner_,1)) as first_char_ascii,
    LEN(Partner_) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY Partner_;

--Which demographic group has the highest churn rate?
SELECT 
	churn,
	gender,
    COUNT(*) as count,
    ASCII(LEFT(churn,1)) as first_char_ascii,
    LEN(churn) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY churn, gender;

--What is the average tenure for our customers?
SELECT
	AVG(tenure)
FROM Customer_Churn

--How does tenure vary between churned and non-churned customers?
SELECT 
	AVG(tenure) AS Tenure_Amount,
	gender,
	Churn,
    COUNT(*) as count,
    ASCII(LEFT(churn,1)) as first_char_ascii,
    LEN(churn) as length,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM customer_churn
GROUP BY churn, gender
