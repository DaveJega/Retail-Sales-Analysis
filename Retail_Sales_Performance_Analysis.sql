-- ==========================================
-- RETAIL SALES PERFORMANCE ANALYSIS
-- Database: RetailSalesDB
-- Table: dbo.Superstore_cleaned
-- Analyst: Data Analyst Portfolio Project
-- ==========================================

-- SECTION 1: DATA QUALITY CHECKS

-- SECTION 2: OVERALL BUSINESS KPIs

-- SECTION 3: CATEGORY PERFORMANCE

-- SECTION 4: REGIONAL PERFORMANCE

-- SECTION 5: DISCOUNT ANALYSIS

-- SECTION 6: MONTHLY SALES AND PROFIT TRENDS

-- SECTION 7: YEAR-OVER-YEAR ANALYSIS

-- SECTION 8: PRODUCT PERFORMANCE

-- SECTION 9: CUSTOMER ANALYSIS

-- SECTION 10: SHIPPING ANALYSIS

-- SECTION 11: SUB-CATEGORY ANALYSIS

-- SECTION 12: CUSTOMER SEGMENTATION

SELECT COUNT(DISTINCT [Order_ID]) AS Total_Orders,
SUM(TRY_CONVERT(DECIMAL(18,4), Sales))
    AS Total_Sales,
SUM(TRY_CONVERT(DECIMAL(18,4), Profit))
    AS Total_Profit,
SUM(TRY_CONVERT(INT, Quantity))
    AS Total_Quantity,
AVG(TRY_CONVERT(DECIMAL(18,4), Discount))
    AS Average_Discount,
SUM(TRY_CONVERT(DECIMAL(18,4), Profit))
    / NULLIF(SUM(TRY_CONVERT(DECIMAL(18,4), Sales)), 0)*100
    AS Profit_Margin,
SUM(TRY_CONVERT(DECIMAL(18,4), Sales))
    / NULLIF(COUNT(DISTINCT [Order_ID]), 0)
    AS Average_Order_Value
FROM dbo.Superstore_cleaned;

SELECT Category,
ROUND(SUM(TRY_CONVERT(DECIMAL(18,4), Sales)), 2)
    AS Total_Sales,

ROUND(SUM(TRY_CONVERT(DECIMAL(18,4), Profit)), 2)
    AS Total_Profit,

SUM(TRY_CONVERT(INT, Quantity))
    AS Total_Quantity_Sold,

ROUND(
    SUM(TRY_CONVERT(DECIMAL(18,4), Profit))
    / NULLIF(SUM(TRY_CONVERT(DECIMAL(18,4), Sales)), 0) * 100,
    2
) AS Profit_Margin_Percentage,

COUNT(DISTINCT [Order_ID])
    AS Total_Orders
FROM dbo.Superstore_cleaned
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Regional Sales and profitability analysis
SELECT Region,
ROUND(SUM(Sales), 2) AS Total_Sales,

ROUND(SUM(Profit), 2) AS Total_Profit,

SUM(Quantity) AS Total_Quantity_Sold,

COUNT(DISTINCT [Order_ID]) AS Total_Orders,

ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Discount Analysis
SELECT CASE WHEN Discount = 0 THEN 'No Discount' WHEN Discount <= 0.20 THEN 'Low Discount' WHEN Discount <= 0.50 THEN 'Medium Discount' ELSE 'High Discount' END AS Discount_Band,
COUNT(*) AS Total_Records,

ROUND(SUM(Sales), 2) AS Total_Sales,

ROUND(SUM(Profit), 2) AS Total_Profit,

ROUND(AVG(Profit), 2) AS Average_Profit,

ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY CASE WHEN Discount = 0 THEN 'No Discount' WHEN Discount <= 0.20 THEN 'Low Discount' WHEN Discount <= 0.50 THEN 'Medium Discount' ELSE 'High Discount' END
ORDER BY MIN(Discount);

-- Monthly sales and profit trend analysis 
SELECT YEAR([Order_Date]) AS Sales_Year,
MONTH([Order_Date]) AS Sales_Month,

DATENAME(MONTH, [Order_Date]) AS Month_Name,

ROUND(SUM(Sales), 2) AS Total_Sales,

ROUND(SUM(Profit), 2) AS Total_Profit,

SUM(Quantity) AS Total_Quantity,

COUNT(DISTINCT [Order_ID]) AS Total_Orders,

ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY YEAR([Order_Date]), MONTH([Order_Date]), DATENAME(MONTH, [Order_Date])
ORDER BY Sales_Year, Sales_Month;

-- Year over Year sales growth
WITH Yearly_Sales AS ( SELECT YEAR([Order_Date]) AS Sales_Year, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit FROM dbo.Superstore_cleaned GROUP BY YEAR([Order_Date]) ),
Sales_Comparison AS ( SELECT Sales_Year, Total_Sales, Total_Profit,
    LAG(Total_Sales) OVER (
        ORDER BY Sales_Year
    ) AS Previous_Year_Sales

FROM Yearly_Sales
)
SELECT Sales_Year,
ROUND(Total_Sales, 2) AS Total_Sales,

ROUND(Total_Profit, 2) AS Total_Profit,

ROUND(Previous_Year_Sales, 2) AS Previous_Year_Sales,

ROUND(
    (Total_Sales - Previous_Year_Sales)
    / NULLIF(Previous_Year_Sales, 0) * 100,
    2
) AS YoY_Sales_Growth_Percentage
FROM Sales_Comparison ORDER BY Sales_Year;

-- Analyse individual product performance
SELECT [Product_Name],
Category,
[Sub_Category],
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(SUM(Profit), 2) AS Total_Profit,
SUM(Quantity) AS Total_Quantity_Sold,
COUNT(DISTINCT [Order_ID]) AS Total_Orders,
ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY [Product_Name], Category, [Sub_Category]
ORDER BY Total_Sales DESC;

-- Analysis of 10 products by sales
WITH Product_Performance AS ( SELECT [Product_Name],
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY
    [Product_Name],
    Category
),
Product_Ranking AS ( SELECT *,
    DENSE_RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank

FROM Product_Performance
)
SELECT Sales_Rank,
[Product_Name],
Category,
ROUND(Total_Sales, 2) AS Total_Sales,
ROUND(Total_Profit, 2) AS Total_Profit
FROM Product_Ranking
WHERE Sales_Rank <= 10
ORDER BY Sales_Rank;

-- Analysis of 10 least performing product
WITH Product_Profit AS ( SELECT [Product_Name],
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY
    [Product_Name],
    Category
)
SELECT TOP 1 [Product_Name],
Category,
ROUND(Total_Sales, 2) AS Total_Sales,
ROUND(Total_Profit, 2) AS Total_Profit
FROM Product_Profit
ORDER BY Total_Profit ASC;

-- Customer performance analysis
SELECT [Customer_ID], [Customer_Name],
COUNT(DISTINCT [Order_ID]) AS Total_Orders,

ROUND(SUM(Sales), 2) AS Total_Sales,

ROUND(SUM(Profit), 2) AS Total_Profit,

SUM(Quantity) AS Total_Quantity,

ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY [Customer_ID], [Customer_Name]
ORDER BY Total_Sales DESC;

-- Top 10 customer by sales 
WITH Customer_Performance AS ( SELECT [Customer_ID], [Customer_Name], SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM dbo.Superstore_cleaned

GROUP BY
    [Customer_ID],
    [Customer_Name]
),
Customer_Ranking AS ( SELECT *, DENSE_RANK() OVER ( ORDER BY Total_Sales DESC ) AS Sales_Rank
FROM Customer_Performance
)
SELECT Sales_Rank, [Customer_ID], [Customer_Name], ROUND(Total_Sales, 2) AS Total_Sales, ROUND(Total_Profit, 2) AS Total_Profit
FROM Customer_Ranking
WHERE Sales_Rank <= 10
ORDER BY Sales_Rank;

-- Top 10 customer by profit
SELECT TOP 10 [Customer_ID], [Customer_Name],
ROUND(SUM(Sales), 2) AS Total_Sales,

ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY [Customer_ID], [Customer_Name]
ORDER BY SUM(Profit) DESC;

-- Loss-making Customers
SELECT [Customer_ID], [Customer_Name],
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY [Customer_ID], [Customer_Name]
HAVING SUM(Profit) < 0
ORDER BY SUM(Profit) ASC;

-- Shipping mode analysis
SELECT [Ship_Mode],
COUNT(DISTINCT [Order_ID]) AS Total_Orders,
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(SUM(Profit), 2) AS Total_Profit,
ROUND(AVG(Discount) * 100, 2)
    AS Average_Discount_Percentage,
ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY [Ship_Mode]
ORDER BY Total_Sales DESC;

--Average delivery time by shipping mode
SELECT [Ship_Mode],
COUNT(*) AS Total_Records,
ROUND(
    AVG(CAST(DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS DECIMAL(10,2))),
    2
) AS Average_Shipping_Days,
MIN(DATEDIFF(DAY, [Order_Date], [Ship_Date]))
    AS Minimum_Shipping_Days,
MAX(DATEDIFF(DAY, [Order_Date], [Ship_Date]))
    AS Maximum_Shipping_Days
FROM dbo.Superstore_cleaned
GROUP BY [Ship_Mode]
ORDER BY Average_Shipping_Days ASC;

-- Analysis of all product sub-categories
SELECT Category, [Sub_Category],
COUNT(DISTINCT [Order_ID]) AS Total_Orders,
ROUND(SUM(Sales), 2) AS Total_Sales,
ROUND(SUM(Profit), 2) AS Total_Profit,
SUM(Quantity) AS Total_Quantity,
ROUND(
    SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM dbo.Superstore_cleaned
GROUP BY Category, [Sub_Category]
ORDER BY Total_Profit DESC;

-- Top 5 most profitable sub-categories
SELECT 
    [Sub_Category],
    ROUND (SUM(Profit), 2) as Total_Profit,
    Round (SUM(Sales), 2) as Total_Sales
FROM dbo.Superstore_cleaned
GROUP by [Sub_Category]
ORDER BY SUM(Profit) DESC;
select * from dbo.Superstore_cleaned

-- lOSS MAKING SUB-CATEGORY
SELECT 
    [Sub_Category],
    ROUND (SUM(Profit), 2) as Total_Profit,
    Round (SUM(Sales), 2) as Total_Sales
FROM dbo.Superstore_cleaned
GROUP by [Sub_Category]
HAVING SUM(Profit) <0
ORDER BY SUM(Profit) ASC;

-- Year over Year Analysis
WITH Annual_Performance AS ( SELECT YEAR([Order_Date]) AS Sales_Year,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY YEAR([Order_Date])
),
Annual_Comparison AS ( SELECT Sales_Year, Total_Sales, Total_Profit,
    LAG(Total_Sales) OVER (
        ORDER BY Sales_Year
    ) AS Previous_Year_Sales,
    LAG(Total_Profit) OVER (
        ORDER BY Sales_Year
    ) AS Previous_Year_Profit
FROM Annual_Performance
)
SELECT Sales_Year,
ROUND(Total_Sales, 2) AS Total_Sales,
ROUND(Total_Profit, 2) AS Total_Profit,
ROUND(Previous_Year_Sales, 2) AS Previous_Year_Sales,
ROUND(
    (Total_Sales - Previous_Year_Sales)
    / NULLIF(Previous_Year_Sales, 0) * 100,
    2
) AS Sales_Growth_Percentage,
ROUND(
    (Total_Profit - Previous_Year_Profit)
    / NULLIF(ABS(Previous_Year_Profit), 0) * 100,
    2
) AS Profit_Growth_Percentage,
ROUND(
    Total_Profit / NULLIF(Total_Sales, 0) * 100,
    2
) AS Profit_Margin_Percentage
FROM Annual_Comparison
ORDER BY Sales_Year;

-- Customer Analysis
WITH Customer_Sales AS ( SELECT [Customer_ID], [Customer_Name], 
SUM(Sales) AS Total_Sales, 
SUM(Profit) AS Total_Profit
FROM dbo.Superstore_cleaned
GROUP BY
    [Customer_ID],
    [Customer_Name]
),
Customer_Segmentation AS ( SELECT *, CASE WHEN Total_Sales >= 5000 THEN 'High Value' 
WHEN Total_Sales >= 2000 THEN 'Medium Value' 
ELSE 'Low Value' END AS Customer_Segment
FROM Customer_Sales
)
SELECT Customer_Segment,
COUNT(*) AS Total_Customers,
ROUND(SUM(Total_Sales), 2) AS Total_Sales,
ROUND(SUM(Total_Profit), 2) AS Total_Profit,
ROUND(AVG(Total_Sales), 2) AS Average_Customer_Sales
FROM Customer_Segmentation
GROUP BY Customer_Segment
ORDER BY Total_Sales DESC;

SELECT
    ROUND(SUM(Sales), 2) AS Overall_Sales,
    ROUND(SUM(Profit), 2) AS Overall_Profit,
    COUNT(DISTINCT [Customer_ID]) AS Total_Customers
FROM dbo.Superstore_cleaned;