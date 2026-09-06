-- Databricks notebook source
---- Chechicking the tye of the columns----
DESCRIBE workspace.default.bright_coffee_shop_sales;

----Inspecting the data----
SELECT *
FROM workspace.default.bright_coffee_shop_sales
LIMIT 10;



----Checking for NULL values----

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date,
    SUM(CASE WHEN transaction_time IS NULL THEN 1 ELSE 0 END) AS null_transaction_time,
    SUM(CASE WHEN transaction_qty IS NULL THEN 1 ELSE 0 END) AS null_transaction_qty,
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_store_id,
    SUM(CASE WHEN store_location IS NULL THEN 1 ELSE 0 END) AS null_store_location,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
    SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) AS null_product_category,
    SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS null_product_type,
    SUM(CASE WHEN product_detail IS NULL THEN 1 ELSE 0 END) AS null_product_detail
FROM workspace.default.bright_coffee_shop_sales;
---- Checking for duplicated-----
SELECT transaction_id,
        COUNT(*) AS Duplicate_cnt
FROM workspace.default.bright_coffee_shop_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

--- Checking the earliest and th latest hour on the dataset----
SELECT
    MIN(HOUR(transaction_time)) AS earliest_hour,
    MAX(HOUR(transaction_time)) AS latest_hour
FROM workspace.default.bright_coffee_shop_sales;

----Cleaning Unit Price----
SELECT unit_price,
CAST(
    REPLACE(TRIM(CAST(unit_price AS STRING)), ',', '.')
    AS DECIMAL(10,2)
) AS unit_price
FROM workspace.default.bright_coffee_shop_sales;


-----Calculating Total Revenue by product_category-----
SELECT product_category,
SUM(transaction_qty) AS total_transaction_qty,
ROUND(SUM(transaction_qty * unit_price), 2) AS Total_Amount
FROM workspace.default.bright_coffee_shop_sales
GROUP BY product_category;

----Cleaning transaction_date and transaction_time----
        
SELECT DISTINCT 
DATE_FORMAT(transaction_time, 'HH:MM:SS') AS Time,

--- The 30 minutes time interval---
FROM_UNIXTIME(
    FLOOR(
        UNIX_TIMESTAMP(transaction_time) / 1800
    ) * 1800
) AS transaction_time_bucket,
DATE_FORMAT(transaction_date, 'MMMM') AS Month,
DAYNAME(TO_DATE(transaction_date)) AS Day_name,

----Classifying transaction time of day----
        CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '6-8.Early Morning'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '9-11.Late Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12-14.Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15-17.Evening'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18-20.Late Evening'
      END AS Transaction_TimeOfDay
FROM workspace.default.bright_coffee_shop_sales;