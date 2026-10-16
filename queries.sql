-- ============================================================
-- Superstore Sales Analytics: SQL queries
-- Database: SQLite (DB Browser for SQLite)
-- Table: SampleSuperstore
-- Columns: Ship Mode, Segment, Country, City, State, Postal Code,
--          Region, Category, Sub-Category, Sales, Quantity,
--          Discount, Profit
-- ============================================================


-- ============================================================
-- PART 1: DATA QUALITY CHECKS
-- ============================================================

-- 1.1 Total number of rows
SELECT COUNT(*) AS TotalRows
FROM SampleSuperstore;

-- 1.2 Check that the header row was not imported as data (should return 0)
SELECT COUNT(*) AS HeaderRowsAsData
FROM SampleSuperstore
WHERE "Sales" = 'Sales';

-- 1.3 Look for fully identical (possibly duplicate) rows
SELECT "Ship Mode", "Segment", "Country", "City", "State", "Postal Code",
       "Region", "Category", "Sub-Category", "Sales", "Quantity",
       "Discount", "Profit",
       COUNT(*) AS RowCount
FROM SampleSuperstore
GROUP BY "Ship Mode", "Segment", "Country", "City", "State", "Postal Code",
         "Region", "Category", "Sub-Category", "Sales", "Quantity",
         "Discount", "Profit"
HAVING COUNT(*) > 1;

-- 1.4 Check for missing (NULL) values in key columns (all should be 0)
SELECT
    SUM(CASE WHEN "Sales"    IS NULL THEN 1 ELSE 0 END) AS NullSales,
    SUM(CASE WHEN "Profit"   IS NULL THEN 1 ELSE 0 END) AS NullProfit,
    SUM(CASE WHEN "Quantity" IS NULL THEN 1 ELSE 0 END) AS NullQuantity,
    SUM(CASE WHEN "Discount" IS NULL THEN 1 ELSE 0 END) AS NullDiscount,
    SUM(CASE WHEN "Region"   IS NULL THEN 1 ELSE 0 END) AS NullRegion
FROM SampleSuperstore;

-- 1.5 Check for impossible values
-- Sales should not be negative; Discount should be between 0 and 1.
-- Profit CAN be negative (loss-making orders), so it is kept.
SELECT MIN("Sales")    AS MinSales,    MAX("Sales")    AS MaxSales,
       MIN("Profit")   AS MinProfit,   MAX("Profit")   AS MaxProfit,
       MIN("Discount") AS MinDiscount, MAX("Discount") AS MaxDiscount
FROM SampleSuperstore;

-- 1.6 Row counts per group (sanity check)
SELECT "Region", COUNT(*) AS RowCount
FROM SampleSuperstore
GROUP BY "Region";


-- ============================================================
-- PART 2: BUSINESS QUESTIONS
-- ============================================================

-- 2.1 Overall totals: headline Sales and Profit
SELECT SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore;

-- 2.2 Sales and profit by Region
SELECT "Region",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore
GROUP BY "Region"
ORDER BY TotalProfit DESC;

-- 2.3 Sales and profit by Category
SELECT "Category",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore
GROUP BY "Category"
ORDER BY TotalProfit DESC;

-- 2.4 Worst-performing Sub-Categories (biggest losses first)
SELECT "Sub-Category",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore
GROUP BY "Sub-Category"
ORDER BY TotalProfit ASC
LIMIT 10;

-- 2.5 Best-performing Sub-Categories
SELECT "Sub-Category",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore
GROUP BY "Sub-Category"
ORDER BY TotalProfit DESC
LIMIT 10;

-- 2.6 Sales, profit and order count by customer Segment
SELECT "Segment",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit,
       COUNT(*)      AS OrderCount
FROM SampleSuperstore
GROUP BY "Segment"
ORDER BY TotalProfit DESC;

-- 2.7 Does discounting hurt margins? Average profit at each discount level
SELECT "Discount",
       AVG("Profit") AS AvgProfit
FROM SampleSuperstore
GROUP BY "Discount"
ORDER BY "Discount";

-- 2.8 Top 10 States by sales
SELECT "State",
       SUM("Sales")  AS TotalSales,
       SUM("Profit") AS TotalProfit
FROM SampleSuperstore
GROUP BY "State"
ORDER BY TotalSales DESC
LIMIT 10;


-- ============================================================
-- PART 3: CALCULATED COLUMNS (cost = Sales - Profit)
-- ============================================================

-- 3.1 Row-level cost ("Investment")
SELECT "Sales", "Profit",
       ("Sales" - "Profit") AS Investment
FROM SampleSuperstore
LIMIT 10;

-- 3.2 Total sales, profit and cost
SELECT SUM("Sales")                  AS TotalSales,
       SUM("Profit")                 AS TotalProfit,
       SUM("Sales") - SUM("Profit")  AS TotalInvestment
FROM SampleSuperstore;

-- 3.3 Cost by Category
SELECT "Category",
       SUM("Sales")                  AS TotalSales,
       SUM("Profit")                 AS TotalProfit,
       SUM("Sales") - SUM("Profit")  AS TotalInvestment
FROM SampleSuperstore
GROUP BY "Category"
ORDER BY TotalInvestment DESC;


-- ============================================================
-- PART 4: EXPORT FOR POWER BI
-- ============================================================

-- Export this result as CSV (File > Export > Table(s) as CSV)
SELECT * FROM SampleSuperstore;
