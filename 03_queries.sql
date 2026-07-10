-- ============================================================
-- DecodeLabs Data Analytics — Project 3: SQL Data Analysis
-- Step 3: Analysis queries
-- Run this THIRD in MySQL Workbench (after schema + data are loaded)
-- ============================================================

USE decodelabs_orders;

-- ------------------------------------------------------------
-- 1. BASIC SELECT
-- Preview the dataset
-- ------------------------------------------------------------
SELECT * FROM orders LIMIT 10;

SELECT OrderID, Product, Quantity, TotalPrice
FROM orders
LIMIT 10;


-- ------------------------------------------------------------
-- 2. WHERE — row-level filtering
-- ------------------------------------------------------------

-- 2a. Orders that were Cancelled
SELECT OrderID, Product, OrderStatus, TotalPrice
FROM orders
WHERE OrderStatus = 'Cancelled';

-- 2b. High-value orders over $1000
SELECT OrderID, Product, TotalPrice
FROM orders
WHERE TotalPrice > 1000
ORDER BY TotalPrice DESC;

-- 2c. Orders with no coupon applied (NULL handling)
SELECT OrderID, Product, CouponCode
FROM orders
WHERE CouponCode IS NULL;

-- 2d. Orders paid by Credit Card in a specific year
SELECT OrderID, OrderDate, PaymentMethod, TotalPrice
FROM orders
WHERE PaymentMethod = 'Credit Card'
  AND OrderDate BETWEEN '2024-01-01' AND '2024-12-31';


-- ------------------------------------------------------------
-- 3. ORDER BY — sorting the result set
-- ------------------------------------------------------------

-- 3a. Top 10 most expensive orders
SELECT OrderID, Product, TotalPrice
FROM orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- 3b. Orders sorted oldest to newest
SELECT OrderID, OrderDate, Product
FROM orders
ORDER BY OrderDate ASC
LIMIT 10;


-- ------------------------------------------------------------
-- 4. GROUP BY + AGGREGATIONS (COUNT, SUM, AVG)
-- ------------------------------------------------------------

-- 4a. Number of orders per product
SELECT Product, COUNT(*) AS TotalOrders
FROM orders
GROUP BY Product
ORDER BY TotalOrders DESC;

-- 4b. Total revenue by product
SELECT Product, SUM(TotalPrice) AS TotalRevenue
FROM orders
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 4c. Average order value by payment method
SELECT PaymentMethod, ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY PaymentMethod
ORDER BY AvgOrderValue DESC;

-- 4d. Order count and revenue by order status
SELECT OrderStatus,
       COUNT(*) AS OrderCount,
       SUM(TotalPrice) AS TotalRevenue,
       ROUND(AVG(TotalPrice), 2) AS AvgOrderValue
FROM orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;

-- 4e. Orders by referral source
SELECT ReferralSource, COUNT(*) AS OrderCount
FROM orders
GROUP BY ReferralSource
ORDER BY OrderCount DESC;

-- 4f. NULL-handling demo: COUNT(*) vs COUNT(CouponCode)
-- COUNT(*) counts every row; COUNT(column) skips NULLs
SELECT
    COUNT(*)         AS TotalRows,
    COUNT(CouponCode) AS RowsWithCoupon,
    COUNT(*) - COUNT(CouponCode) AS RowsMissingCoupon
FROM orders;


-- ------------------------------------------------------------
-- 5. HAVING — filtering AGGREGATED groups (bonus, per deck)
-- Remember: WHERE filters rows BEFORE grouping,
--           HAVING filters groups AFTER aggregation.
-- ------------------------------------------------------------

-- 5a. Products that generated more than $50,000 in total revenue
SELECT Product, SUM(TotalPrice) AS TotalRevenue
FROM orders
GROUP BY Product
HAVING SUM(TotalPrice) > 50000
ORDER BY TotalRevenue DESC;

-- 5b. Payment methods used in more than 200 orders
SELECT PaymentMethod, COUNT(*) AS OrderCount
FROM orders
GROUP BY PaymentMethod
HAVING COUNT(*) > 200
ORDER BY OrderCount DESC;


-- ------------------------------------------------------------
-- 6. PERCENTAGE CONTRIBUTION (bonus, per deck)
-- Uses a subquery because you can't reference a SELECT alias
-- inside the same-level WHERE/GROUP BY calculation (the "alias trap").
-- ------------------------------------------------------------

SELECT
    Product,
    SUM(TotalPrice) AS ProductRevenue,
    ROUND(
        SUM(TotalPrice) * 100.0 / (SELECT SUM(TotalPrice) FROM orders),
        2
    ) AS PctOfTotalRevenue
FROM orders
GROUP BY Product
ORDER BY PctOfTotalRevenue DESC;


-- ------------------------------------------------------------
-- 7. Combined filter + group + aggregate + sort example
-- (shows the full execution order: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY)
-- ------------------------------------------------------------

SELECT
    Product,
    COUNT(*) AS DeliveredOrders,
    SUM(TotalPrice) AS DeliveredRevenue
FROM orders
WHERE OrderStatus = 'Delivered'
GROUP BY Product
HAVING COUNT(*) >= 20
ORDER BY DeliveredRevenue DESC;
