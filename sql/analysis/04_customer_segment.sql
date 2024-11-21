--What are the characteristics of customers who stay longest?
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)

-- Now let's analyze different characteristics
SELECT 
    'Contract Analysis' as characteristic,
    Contract_,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY Contract_

UNION ALL

SELECT 
    'Payment Method Analysis' as characteristic,
    PaymentMethod,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY PaymentMethod

UNION ALL

SELECT 
    'Internet Service Analysis' as characteristic,
    InternetService,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY InternetService

-- Analyze additional services adoption
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)

SELECT 
    'Additional Services' as service_type,
    SUM(CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as online_security_pct,
    SUM(CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as online_backup_pct,
    SUM(CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as device_protection_pct,
    SUM(CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as tech_support_pct,
    SUM(CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as streaming_tv_pct,
    SUM(CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as streaming_movies_pct
FROM LongTermCustomers

-- Analyze demographic characteristics
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)
SELECT 
    'Demographics' as characteristic,
    CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior'
        ELSE 'Non-Senior'
    END as customer_type,
    gender,
    CASE 
        WHEN Partner_ LIKE '%Yes%' THEN 'Has Partner'
        ELSE 'No Partner'
    END as partner_status,
    CASE 
        WHEN Dependents LIKE '%Yes%' THEN 'Has Dependents'
        ELSE 'No Dependents'
    END as dependent_status,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months
FROM LongTermCustomers
GROUP BY 
    SeniorCitizen,
    gender,
    Partner_,
    Dependents
ORDER BY avg_tenure_months DESC;

-- Analyze monthly charges distribution
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)
SELECT 
    'Monthly Charges Distribution' as analysis_type,
    MIN(MonthlyCharges) as min_charges,
    MAX(MonthlyCharges) as max_charges,
    AVG(MonthlyCharges) as avg_charges,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY AVG(MonthlyCharges)) OVER() as median_charges
FROM LongTermCustomers


--What are the common characteristics of customers who churned?
-- First, let's analyze demographic characteristics of churned customers
SELECT 
    'Demographics' as analysis_type,
    COUNT(*) as total_churned,
    -- Senior Citizen Analysis
    SUM(CASE WHEN SeniorCitizen = 1 THEN 1 ELSE 0 END) as senior_count,
    CAST(SUM(CASE WHEN SeniorCitizen = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as senior_percentage,
    
    -- Gender Analysis
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) as male_count,
    CAST(SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as male_percentage,
    
    -- Partner Status
    SUM(CASE WHEN Partner_ LIKE '%Yes%' THEN 1 ELSE 0 END) as with_partner_count,
    CAST(SUM(CASE WHEN Partner_ LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as with_partner_percentage,
    
    -- Dependents Status
    SUM(CASE WHEN Dependents LIKE '%Yes%' THEN 1 ELSE 0 END) as with_dependents_count,
    CAST(SUM(CASE WHEN Dependents LIKE '%Yes%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as with_dependents_percentage
FROM customer_churn
WHERE churn LIKE '%Yes%';

-- Analyze contract and service characteristics
SELECT 
    'Service Analysis' as analysis_type,
    Contract_,
    InternetService,
    COUNT(*) as customer_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_of_churned,
    CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months
FROM customer_churn
WHERE churn LIKE '%Yes%'
GROUP BY Contract_, InternetService
ORDER BY customer_count DESC;

-- Analyze additional services among churned customers
SELECT 
    'Additional Services' as analysis_type,
    SUM(CASE WHEN OnlineSecurity LIKE '%Yes%' THEN 1 ELSE 0 END) as with_security,
    SUM(CASE WHEN OnlineBackup LIKE '%Yes%' THEN 1 ELSE 0 END) as with_backup,
    SUM(CASE WHEN DeviceProtection LIKE '%Yes%' THEN 1 ELSE 0 END) as with_protection,
    SUM(CASE WHEN TechSupport LIKE '%Yes%' THEN 1 ELSE 0 END) as with_support,
    SUM(CASE WHEN StreamingTV LIKE '%Yes%' THEN 1 ELSE 0 END) as with_tv,
    SUM(CASE WHEN StreamingMovies LIKE '%Yes%' THEN 1 ELSE 0 END) as with_movies,
    COUNT(*) as total_churned,
    CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges
FROM customer_churn
WHERE churn LIKE '%Yes%';

-- Analyze payment methods and billing
SELECT 
    'Payment Analysis' as analysis_type,
    PaymentMethod,
    COUNT(*) as customer_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_of_churned,
    CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges,
    CAST(AVG(TotalCharges) AS DECIMAL(10,2)) as avg_total_charges
FROM customer_churn
WHERE churn LIKE '%Yes%'
GROUP BY PaymentMethod
ORDER BY customer_count DESC;

-- Analyze tenure distribution of churned customers
SELECT 
    'Tenure Analysis' as analysis_type,
    CASE 
        WHEN tenure <= 6 THEN '0-6 months'
        WHEN tenure <= 12 THEN '7-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        ELSE 'Over 24 months'
    END as tenure_group,
    COUNT(*) as customer_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage_of_churned,
    CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges
FROM customer_churn
WHERE churn LIKE '%Yes%'
GROUP BY 
    CASE 
        WHEN tenure <= 6 THEN '0-6 months'
        WHEN tenure <= 12 THEN '7-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        ELSE 'Over 24 months'
    END


--Which customer segment (combination of characteristics) has the highest churn rate?
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)

-- Now let's analyze different characteristics
SELECT 
    'Contract Analysis' as characteristic,
    Contract_,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM LongTermCustomers
GROUP BY Contract_

UNION ALL

SELECT 
    'Payment Method Analysis' as characteristic,
    PaymentMethod,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM LongTermCustomers
GROUP BY PaymentMethod

UNION ALL

SELECT 
    'Internet Service Analysis' as characteristic,
    InternetService,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage,
	CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM LongTermCustomers
GROUP BY InternetService

--Which customer segment generates the highest revenue?
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
)

-- Now let's analyze different characteristics
SELECT 
    'Contract Analysis' as characteristic,
    Contract_,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY Contract_

UNION ALL

SELECT 
    'Payment Method Analysis' as characteristic,
    PaymentMethod,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY PaymentMethod

UNION ALL

SELECT 
    'Internet Service Analysis' as characteristic,
    InternetService,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(SUM(TotalCharges) AS FLOAT) as total_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY InternetService

--What's the profile of customers with the highest monthly charges?
WITH LongTermCustomers AS (
    SELECT *
    FROM customer_churn
    WHERE tenure > (SELECT AVG(tenure) FROM customer_churn)
	AND MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM customer_churn)
)

-- Now let's analyze different characteristics
SELECT 
    'Contract Analysis' as characteristic,
    Contract_,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY Contract_

UNION ALL

SELECT 
    'Payment Method Analysis' as characteristic,
    PaymentMethod,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY PaymentMethod

UNION ALL

SELECT 
    'Internet Service Analysis' as characteristic,
    InternetService,
    COUNT(*) as customer_count,
    CAST(AVG(tenure) AS DECIMAL(10,2)) as avg_tenure_months,
	CAST(AVG(MonthlyCharges) AS DECIMAL(10,2)) as avg_monthly_charges,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) as percentage
FROM LongTermCustomers
GROUP BY InternetService

