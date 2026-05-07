-- ============================================================
-- SUPERSTORE SALES ANALYSIS — SQL Queries
-- Business Analyst Portfolio | Tanya Sarwan
-- Dataset: train.csv | 9,800 rows | SQLite
-- ============================================================


-- QUERY 1: Total Revenue & Business Overview
-- Business Purpose: Executive snapshot of overall business performance
SELECT
    ROUND(SUM(Sales), 2) AS total_revenue,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    ROUND(AVG(Sales), 2) AS avg_order_value
FROM train;


-- QUERY 2: Revenue by Category
-- Business Purpose: Identify which product category drives the most revenue
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY Category
ORDER BY total_revenue DESC;


-- QUERY 3: Revenue by Category and Sub-Category
-- Business Purpose: Drill down to find highest and lowest performing product lines
SELECT
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY Category, "Sub-Category"
ORDER BY total_revenue DESC;


-- QUERY 4: Revenue by Region and State
-- Business Purpose: Regional performance analysis to guide sales strategy
SELECT
    Region,
    State,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY Region, State
ORDER BY total_revenue DESC;


-- QUERY 5: Top 10 Customers by Revenue
-- Business Purpose: Identify highest value customers for retention strategy
SELECT
    "Customer ID",
    "Customer Name",
    Segment,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY "Customer ID", "Customer Name", Segment
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 6: Revenue by Customer Segment
-- Business Purpose: Compare Consumer vs Corporate vs Home Office contribution
SELECT
    Segment,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue,
    ROUND(AVG(Sales), 2) AS avg_order_value
FROM train
GROUP BY Segment
ORDER BY total_revenue DESC;


-- QUERY 7: Revenue by Shipping Mode
-- Business Purpose: Understand shipping preference and its revenue impact
SELECT
    "Ship Mode",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue,
    ROUND(AVG(Sales), 2) AS avg_order_value
FROM train
GROUP BY "Ship Mode"
ORDER BY total_revenue DESC;


-- QUERY 8: Monthly Sales Trend
-- Business Purpose: Track monthly revenue patterns and seasonality
SELECT
    strftime('%Y-%m', "Order Date") AS order_month,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY strftime('%Y-%m', "Order Date")
ORDER BY order_month;


-- QUERY 9: Yearly Sales Trend
-- Business Purpose: Track year-over-year business growth
SELECT
    strftime('%Y', "Order Date") AS order_year,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY strftime('%Y', "Order Date")
ORDER BY order_year;


-- QUERY 10: Top 10 Performing Cities
-- Business Purpose: Identify key revenue-generating cities
SELECT
    City,
    State,
    Region,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY City, State, Region
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 11: Bottom 10 Performing Cities
-- Business Purpose: Identify underperforming markets needing attention
SELECT
    City,
    State,
    Region,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_revenue
FROM train
GROUP BY City, State, Region
ORDER BY total_revenue ASC
LIMIT 10;


-- QUERY 12: Average Shipping Days by Ship Mode
-- Business Purpose: Measure shipping efficiency and operational performance
SELECT
    "Ship Mode",
    ROUND(AVG(julianday("Ship Date") - julianday("Order Date")), 2) AS avg_shipping_days,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(AVG(Sales), 2) AS avg_order_value
FROM train
GROUP BY "Ship Mode"
ORDER BY avg_shipping_days;


-- QUERY 13: Repeat vs One-Time Customers
-- Business Purpose: Measure customer retention and loyalty
SELECT
    customer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT "Customer ID") FROM train), 2) AS percentage
FROM (
    SELECT
        "Customer ID",
        CASE
            WHEN COUNT(DISTINCT "Order ID") = 1 THEN 'One-time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM train
    GROUP BY "Customer ID"
)
GROUP BY customer_type;
