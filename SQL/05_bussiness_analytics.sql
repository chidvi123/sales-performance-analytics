USE sales_analytics;

-- Query 1: Overall Business Performance
-- How much revenue, quantity, and profit did the business generate overall?


SELECT 
    ROUND(SUM(sales), 2) AS total_revenue,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales;


-- Query 2: Business Scale Analysis
-- How many customers, products, and orders does the business have?

SELECT 
(SELECT COUNT(*) FROM customers) AS total_customers,
(SELECT COUNT(*) FROM products) AS total_products,
(SELECT COUNT(*) FROM orders) AS total_orders;


-- Query 3: Average Order Value (AOV)
-- What is the average revenue generated per order?

SELECT 
    ROUND(
    SUM(sales)/COUNT(DISTINCT order_id),
    2
    )AS average_order_value
FROM sales;

-- Query 4: Average Profit Per Order
-- How much profit does the company make per order on average?

SELECT 
    ROUND(
        SUM(profit) / COUNT(DISTINCT order_id),
        2
    ) AS average_profit_per_order
FROM sales;

-- Query 5: Overall Profit Margin %
-- How efficiently is the company converting revenue into profit?

SELECT 
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percentage
FROM sales;


-- Query 6: Sales and Profit by Category Business Question
-- Which product categories generate the highest sales and profit?

SELECT
    p.category,
    ROUND(SUM(s.sales), 2) AS total_sales,
    ROUND(SUM(s.profit), 2) AS total_profit,
    SUM(s.quantity) AS units_sold
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- Query 7: Sales and Profit by Sub-Category
-- Which sub-categories generate the highest sales and profit?

SELECT
p.sub_category,
ROUND(SUM(s.sales),2) AS total_sales,
ROUND(SUM(s.profit),2) AS total_profit,
SUM(s.quantity) AS units_sold 
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY total_sales DESC;


-- Query 8: Top 10 Products by Revenue
-- Which individual products generate the highest revenue?

SELECT 
p.product_name,
ROUND(SUM(s.sales),2) AS total_revenue
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 9: Top 10 Products by Profit
SELECT p.product_name,
ROUND(SUM(s.profit),2) AS total_profit
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Query 10: Top 10 Products by Quantity Sold
-- Which products are sold the most?

SELECT 
p.product_name,
SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY total_units_sold DESC
LIMIT 10;


-- Query 11: Loss-Making Products
-- Which products are causing losses to the company?

SELECT
    p.product_name,
    ROUND(SUM(s.profit), 2) AS total_loss
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.profit) < 0
ORDER BY total_loss ASC
LIMIT 10;


-- Query 12: Category Contribution to Total Sales %
-- Out of the company's total revenue, how much does each category contribute?

SELECT 
p.category,
ROUND(SUM(s.sales),2) AS total_sales,
ROUND(
(SUM(s.sales)/(SELECT SUM(sales) FROM sales))*100,2) AS sales_contribution_percent
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;



-- Query 13: Top 10 Customers by Revenue
-- Which customers generate the most revenue?

SELECT 
c.customer_name,
ROUND(SUM(s.sales),2) AS total_revenue
FROM sales s
JOIN orders o
ON s.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;



-- Query 14: Top 10 Customers by Profit
-- Which customers generate the most profit?
SELECT
    c.customer_name,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM sales s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_profit DESC
LIMIT 10;


-- Query 15: Customer Segment Analysis
-- Which customer segment contributes the most sales and profit?

SELECT
    c.segment,
    ROUND(SUM(s.sales), 2) AS total_sales,
    ROUND(SUM(s.profit), 2) AS total_profit,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM sales s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;

-- Query 16: Average Revenue per Customer
-- On average, how much revenue does each customer generate?

SELECT
    ROUND(
        SUM(s.sales) / COUNT(DISTINCT c.customer_id),
        2
    ) AS avg_revenue_per_customer
FROM sales s
JOIN orders o
    ON s.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id;
    

-- Query 17: Top Customers by Number of Orders
-- Which customers place the highest number of orders?

SELECT 
c.customer_name,
COUNT(o.order_id) as total_orders
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_orders DESC
LIMIT 10;

-- Query 18: Yearly Sales Trend
-- How has the company's sales and profit changed year by year?

SELECT 
YEAR(o.order_date) AS order_year,
ROUND(SUM(s.sales),2) AS total_sales,
ROUND(SUM(s.profit),2) AS total_profit
FROM orders o
JOIN sales s
ON o.order_id=s.order_id
GROUP BY YEAR(o.order_date)
ORDER BY order_year;


-- Query 19: Monthly Sales Trend
-- How do sales vary month by month?

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(s.sales), 2) AS total_sales,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM orders o
JOIN sales s
    ON o.order_id = s.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    order_year,
    order_month;
    
    
   
-- query 20:Monthly Profit Trend
-- How has profit changed month by month?


SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM orders o
JOIN sales s
    ON o.order_id = s.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    order_year,
    order_month;

-- Query 21: Sales and Profit by Region
-- Which region generates the highest sales and profit?

SELECT
r.region,
ROUND(SUM(s.sales),2) AS total_sales,
ROUND(SUM(s.profit),2) AS total_profit
FROM regions r
JOIN orders o
ON o.region_id=r.region_id
JOIN sales s
ON o.order_id=s.order_id
GROUP BY r.region
ORDER BY total_sales DESC;

-- Query 22: Sales by State
-- Which states generate the highest sales and profit?

SELECT
r.state,
ROUND(SUM(s.sales),2) AS total_sales,
ROUND(SUM(s.profit),2) AS total_profit
FROM regions r
JOIN orders o
ON o.region_id=r.region_id
JOIN sales s
ON o.order_id=s.order_id
GROUP BY r.state
ORDER BY total_sales DESC;


-- Query 23: Top 10 Cities by Sales
-- Which cities generate the highest sales and profit?

SELECT 
r.city,
ROUND(SUM(s.sales),2) as total_sales,
ROUND(SUM(s.profit),2) as total_profit
FROM regions r
JOIN orders o
ON o.region_id=r.region_id
JOIN sales s
ON o.order_id=s.order_id
GROUP BY r.city
ORDER BY total_sales DESC
LIMIT 10;



-- Query 24: Discount Impact on Profit
-- How does discount affect sales and profit?

SELECT
    discount,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_units_sold
FROM sales
GROUP BY discount
ORDER BY discount;

-- Query 25: High Discount Products
-- Which products have the highest average discount, and how profitable are they?

SELECT
    p.product_name,
    ROUND(AVG(s.discount), 2) AS avg_discount,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM products p
JOIN sales s
    ON p.product_id = s.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING AVG(s.discount) >= 0.30
ORDER BY avg_discount DESC, total_profit;

-- Query 26: Running Total Sales (Window Function)
-- How does cumulative (running) sales grow over time?

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    ROUND(SUM(s.sales), 2) AS monthly_sales,
    ROUND(
        SUM(SUM(s.sales)) OVER (
            ORDER BY YEAR(o.order_date), MONTH(o.order_date)
        ),
        2
    ) AS running_total_sales
FROM orders o
JOIN sales s
    ON o.order_id = s.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    order_year,
    order_month;
    
    
-- Query 27: Rank Products by Total Sales
-- Rank all products based on their total sales.

SELECT 
p.product_id,
p.product_name,
ROUND(SUM(s.sales)) as total_sales,
RANK()OVER(
ORDER BY SUM(s.sales) DESC
) AS sales_rank
FROM products P
JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_id,p.product_name
ORDER BY sales_rank;


-- Query 28: Top Product in Each Category
-- Which product has the highest total sales in each category?


-- this gives all products but we want the only top products in all 3 categories

SELECT
p.product_name,
P.category,
ROUND(SUM(s.sales)) as total_sales
FROM products p
JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_id,p.category
ORDER BY total_sales DESC;

-- this is the correct solution 

WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        ROUND(SUM(s.sales), 2) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(s.sales) DESC
        ) AS sales_rank
    FROM products p
    JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY
        p.category,
        p.product_id,
        p.product_name
)
SELECT
    category,
    product_name,
    total_sales
FROM product_sales
WHERE sales_rank = 1
ORDER BY category;

-- Query 29: Month-over-Month Sales Growth
-- How did sales change compared to the previous month?

WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        ROUND(SUM(s.sales), 2) AS total_sales
    FROM orders o
    JOIN sales s
        ON o.order_id = s.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)

SELECT
    order_year,
    order_month,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_sales,
    ROUND(
        total_sales -
        LAG(total_sales) OVER (
            ORDER BY order_year, order_month
        ),
        2
    ) AS sales_difference
FROM monthly_sales
ORDER BY
    order_year,
    order_month;


-- Query 30: Top 10 Highest Revenue Orders
-- Which orders generated the highest revenue?

SELECT 
o.order_id,
c.customer_name,
ROUND(SUM(s.sales)) as total_order_value,
SUM(s.quantity) as total_items
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
JOIN sales s
ON o.order_id=s.order_id
GROUP BY o.order_id,c.customer_name
ORDER BY total_order_value DESC
LIMIT 10;

SELECT * FROM products;
