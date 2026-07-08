-- Load Customers

USE sales_analytics;

INSERT INTO customers (
    customer_id,
    customer_name,
    segment
)
SELECT
    customer_id,
    MIN(customer_name),
    MIN(segment)
FROM superstore_raw
GROUP BY customer_id;


-- Load Products

INSERT INTO products (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT
    product_id,
    MIN(product_name),
    MIN(category),
    MIN(sub_category)
FROM superstore_raw
GROUP BY product_id;


-- Load Regions

INSERT INTO regions (
    country,
    region,
    state,
    city,
    postal_code
)
SELECT DISTINCT
    country,
    region,
    state,
    city,
    postal_code
FROM superstore_raw;


-- Load Orders

INSERT INTO orders (
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    region_id
)
SELECT DISTINCT
    s.order_id,
    STR_TO_DATE(s.order_date, '%Y-%m-%d'),
    STR_TO_DATE(s.ship_date, '%Y-%m-%d'),
    s.ship_mode,
    s.customer_id,
    r.region_id
FROM superstore_raw s
JOIN regions r
    ON s.country = r.country
    AND s.region = r.region
    AND s.state = r.state
    AND s.city = r.city
    AND s.postal_code = r.postal_code;
    


-- Load Sales

INSERT INTO sales (
    order_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    order_id,
    product_id,
    SUM(sales),
    SUM(quantity),
    AVG(discount),
    SUM(profit)
FROM superstore_raw
GROUP BY
    order_id,
    product_id;
    
