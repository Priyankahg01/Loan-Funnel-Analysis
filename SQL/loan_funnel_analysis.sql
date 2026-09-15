-- Loan Funnel Analysis
-- SQL Analysis Queries
-- Project: Loan Application Funnel Analysis

USE loan_funnel_analysis;

-- 1. Loan Application Funnel

SELECT
    COUNT(*) AS total_applications,
    SUM(Approval_Status = 'Approved') AS approved,
    ROUND(
        SUM(Approval_Status = 'Approved') / COUNT(*) * 100,
        2
    ) AS approval_rate,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS overall_processing_rate,
    SUM(Actual_Repayment_Date IS NOT NULL) AS repayment_recorded
FROM loan_applications;

-- 2. Funnel Drop-off Analysis

SELECT
    ROUND((993 - 614) / 993 * 100, 2) AS approved_to_processed_dropoff,
    ROUND((614 - 613) / 614 * 100, 2) AS processed_to_repayment_dropoff,
    ROUND((1000 - 613) / 1000 * 100, 2) AS overall_dropoff;
    
    -- 3. Processing Rate by Product Type

SELECT
    Product_Type,
    COUNT(*) AS applications,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS processing_rate
FROM loan_applications
GROUP BY Product_Type
ORDER BY processing_rate DESC;

-- 4. Processing Rate by Customer Income Level

SELECT
    Customer_Income_Level,
    COUNT(*) AS applications,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS processing_rate
FROM loan_applications
GROUP BY Customer_Income_Level
ORDER BY processing_rate DESC;

-- 5. Processing Rate by Credit Score

SELECT
    Customer_Credit_Score,
    COUNT(*) AS applications,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS processing_rate
FROM loan_applications
GROUP BY Customer_Credit_Score
ORDER BY processing_rate DESC;

-- 6. Processing Rate by Sales Representative

SELECT
    Sales_Rep_Name,
    COUNT(*) AS applications,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS processing_rate
FROM loan_applications
GROUP BY Sales_Rep_Name
ORDER BY processing_rate DESC;

-- 7. Processing Rate by Pre-Application Call

SELECT
    Had_Pre_Application_Call,
    COUNT(*) AS applications,
    SUM(Loan_Processed = 'True') AS processed,
    ROUND(
        SUM(Loan_Processed = 'True') / COUNT(*) * 100,
        2
    ) AS processing_rate
FROM loan_applications
GROUP BY Had_Pre_Application_Call
ORDER BY processing_rate DESC;

-- 8. Repayment Status Analysis

SELECT
    Repayment_Status,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) / (
            SELECT COUNT(*)
            FROM loan_applications
            WHERE Repayment_Status IS NOT NULL
              AND Repayment_Status <> '\\N'
        ) * 100,
        2
    ) AS percentage
FROM loan_applications
WHERE Repayment_Status IS NOT NULL
  AND Repayment_Status <> '\\N'
GROUP BY Repayment_Status
ORDER BY customers DESC;

-- 9. Average Loan Amount and Interest Rate by Product

SELECT
    Product_Type,
    COUNT(*) AS applications,
    ROUND(AVG(Loan_Amount), 2) AS avg_loan_amount,
    ROUND(AVG(Loan_Interest_Rate) * 100, 2) AS avg_interest_rate
FROM loan_applications
GROUP BY Product_Type
ORDER BY avg_loan_amount DESC;

-- 10. Data Quality Check

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    SUM(Customer_ID IS NULL) AS missing_customer_ids,
    SUM(Application_Date IS NULL) AS missing_application_dates,
    SUM(Approval_Status IS NULL) AS missing_approval_status,
    SUM(Loan_Amount IS NULL) AS missing_loan_amounts
FROM loan_applications;