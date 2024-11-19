/*
File: 01_initial_checks.sql
Description: Initial data quality and structure verification
Author: [Your Name]
Date: [Current Date]
*/

-- Check table structure
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_churn';

-- Check for null values and basic statistics
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT customerID) as unique_customers,
    SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) as churned_customers,
    CAST(
        (CAST(SUM(CASE WHEN churn LIKE '%Yes%' THEN 1 ELSE 0 END) AS FLOAT) / 
        CAST(COUNT(*) AS FLOAT)) * 100 
    AS DECIMAL(10,2)) as churn_rate_percentage
FROM customer_churn;
