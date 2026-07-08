USE sales_analytics;

SELECT COUNT(*) AS raw_rows
FROM superstore_raw;

SELECT COUNT(*) AS customers
FROM customers;

SELECT COUNT(*) AS products
FROM products;

SELECT COUNT(*) AS regions
FROM regions;

SELECT COUNT(*) AS orders
FROM orders;

SELECT COUNT(*) AS sales
FROM sales;


SELECT COUNT(DISTINCT customer_id) AS unique_customers_in_raw
FROM superstore_raw;


SELECT COUNT(*) AS null_customer_ids
FROM superstore_raw
WHERE customer_id IS NULL;