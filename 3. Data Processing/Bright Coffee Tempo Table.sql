-- Databricks notebook source
----CREATING A TEMP TABLE THAT WILL ONLY CONSIST OF THE CLEANED COLUMNS----

CREATE OR REPLACE TABLE BRIGHT_COFFEE_CLEANED AS
SELECT 
      transaction_id,
      DATE_FORMAT(transaction_time, 'HH:MM:SS') AS Time,
      FROM_UNIXTIME(
        FLOOR(
          UNIX_TIMESTAMP(transaction_time) / 1800
        ) * 1800
      ) AS transaction_time_bucket,
      DATE_FORMAT(transaction_date, 'MMMM') AS Month,
      DAYNAME(TO_DATE(transaction_date)) AS Day,
      CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '6-8.Morning'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '9-11.Late Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12-14.Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15-17.Evening'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18.20.Late Evening'
      END AS Transaction_TimeOfDay,
      transaction_qty,
      CAST(
        REPLACE(TRIM(CAST(unit_price AS STRING)), ',', '.')
        AS DECIMAL(10,2)
      ) AS unit_price,
      transaction_qty * unit_price AS Total_Amount,
      CAST(product_id AS INT) AS product_id,
      CAST(store_id AS INT) AS store_id,
  ----REMOVES UNNECESSARY SPACES IN STRING VALUES-----
      TRIM(store_location) AS store_location,
      TRIM(product_category) AS product_category,
      TRIM(product_type) AS product_type,
      TRIM(product_detail) AS product_detail
FROM workspace.default.bright_coffee_shop_sales;

----Viewing the Cleaned table I created----
SELECT * 
FROM BRIGHT_COFFEE_CLEANED;
   



SELECT COUNT(*) AS row_count
FROM BRIGHT_COFFEE_CLEANED;