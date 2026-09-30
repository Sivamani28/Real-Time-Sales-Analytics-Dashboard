## create database

CREATE DATABASE superstore_db;

USE superstore_db;

DROP TABLE superstore;

## Create the table

CREATE TABLE superstore (
    `Row ID` INT,
    `Order ID` VARCHAR(50),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(50),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country/Region` VARCHAR(100),
    `City` VARCHAR(100),
    `State/Province` VARCHAR(100),
    `Postal Code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    `Sales` DECIMAL(12,4),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(12,4)
);

DESCRIBE superstore;

## Create a staging table

CREATE TABLE superstore_raw (
    `Row ID` INT,
    `Order ID` VARCHAR(50),
    `Order Date` VARCHAR(20),
    `Ship Date` VARCHAR(20),
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(50),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country/Region` VARCHAR(100),
    `City` VARCHAR(100),
    `State/Province` VARCHAR(100),
    `Postal Code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    `Sales` DECIMAL(12,4),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(12,4)
);

DESCRIBE superstore_raw;

## Enable local file loading

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

## Import your file

USE superstore_db;

LOAD DATA LOCAL INFILE 'D:/superstore.csv'
INTO TABLE superstore_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

## Check your database tables

show tables;

SELECT COUNT(*) AS raw_rows
FROM superstore_raw;

SELECT COUNT(*) AS final_rows
FROM superstore;

## Move the data from superstore_raw into the final table

USE superstore_db;

INSERT INTO superstore (
    `Row ID`,
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `Country/Region`,
    `City`,
    `State/Province`,
    `Postal Code`,
    `Region`,
    `Product ID`,
    `Category`,
    `Sub-Category`,
    `Product Name`,
    `Sales`,
    `Quantity`,
    `Discount`,
    `Profit`
)
SELECT
    `Row ID`,
    `Order ID`,
    STR_TO_DATE(`Order Date`, '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(`Ship Date`, '%Y-%m-%d %H:%i:%s'),
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `Country/Region`,
    `City`,
    `State/Province`,
    `Postal Code`,
    `Region`,
    `Product ID`,
    `Category`,
    `Sub-Category`,
    `Product Name`,
    `Sales`,
    `Quantity`,
    `Discount`,
    `Profit`
FROM superstore_raw;

## Check one date

SELECT `Order Date`
FROM superstore_raw
LIMIT 1;

## Test the conversion

SELECT STR_TO_DATE(`Order Date`, '%Y-%m-%d %H:%i:%s') AS converted_date
FROM superstore_raw
LIMIT 1;

TRUNCATE TABLE superstore;

## Verify the final table

SELECT COUNT(*) AS total_rows
FROM superstore;

SELECT *
FROM superstore
LIMIT 5;

## check the dates

SELECT `Order Date`, `Ship Date`
FROM superstore
LIMIT 5;

## Check for missing values

SELECT
    COUNT(*) AS total_rows,
    SUM(`Order ID` IS NULL) AS missing_order_id,
    SUM(`Customer ID` IS NULL) AS missing_customer_id,
    SUM(`Product ID` IS NULL) AS missing_product_id,
    SUM(`Sales` IS NULL) AS missing_sales,
    SUM(`Profit` IS NULL) AS missing_profit
FROM superstore;

## Total Sales

SELECT 
    SUM(Sales) AS Total_Sales
FROM superstore;

## Total Profit

SELECT 
    SUM(Profit) AS Total_Profit
FROM superstore;

## Total Quantity

SELECT 
    SUM(Quantity) AS Total_Quantity
FROM superstore;

## Average Discount

SELECT 
    AVG(Discount) AS Average_Discount
FROM superstore;

## Sales by Category

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

## Profit by Category

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Profit DESC;

## Sales and Profit by Category

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

## Sales by Region

SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

## Profit by Region

SELECT
    Region,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Profit DESC;

## Sales and Profit by Region

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

## Sales by Sub-Category

SELECT
    `Sub-Category`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Sales DESC;

## Profit by Sub-Category

SELECT
    `Sub-Category`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Profit DESC;

## Top 10 Products by Sales

SELECT
    `Product Name`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;

## Top 10 Customers by Sales

SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

## Sales by Segment

SELECT
    Segment,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;

## Profit by Segment

SELECT
    Segment,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Segment
ORDER BY Total_Profit DESC;

## Sales by Ship Mode

SELECT
    `Ship Mode`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Ship Mode`
ORDER BY Total_Sales DESC;

## Profit by Ship Mode

SELECT
    `Ship Mode`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Ship Mode`
ORDER BY Total_Profit DESC;

## Top 10 States by Sales

SELECT
    `State/Province`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `State/Province`
ORDER BY Total_Sales DESC
LIMIT 10;

## Top 10 States by Profit

SELECT
    `State/Province`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `State/Province`
ORDER BY Total_Profit DESC
LIMIT 10;

## Bottom 10 States by Profit

SELECT
    `State/Province`,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `State/Province`
ORDER BY Total_Profit ASC
LIMIT 10;

## Yearly Sales and Profit

SELECT
    YEAR(`Order Date`) AS Order_Year,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY YEAR(`Order Date`)
ORDER BY Order_Year;

## Monthly Sales and Profit

SELECT
    YEAR(`Order Date`) AS Order_Year,
    MONTH(`Order Date`) AS Order_Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY
    YEAR(`Order Date`),
    MONTH(`Order Date`)
ORDER BY
    Order_Year,
    Order_Month;
    
## Profit Margin by Category

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;

## Profit Margin by Region

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY Region
ORDER BY Profit_Margin_Percent DESC;

## Profit Margin by Sub-Category

SELECT
    `Sub-Category`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Profit_Margin_Percent DESC;

## Top 10 Products by Profit

SELECT
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Profit DESC
LIMIT 10;

## Top 10 Loss-Making Products

SELECT
    `Product Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

## Discount vs Profit

SELECT
    Discount,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Discount
ORDER BY Discount;

## Average Sales per Order

SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS Average_Sales_Per_Order
FROM superstore;

## Average Profit per Order

SELECT
    ROUND(SUM(Profit) / COUNT(DISTINCT `Order ID`), 2) AS Average_Profit_Per_Order
FROM superstore;

## CTE: Top Categories by Profit

WITH category_profit AS (
    SELECT
        Category,
        SUM(Profit) AS Total_Profit
    FROM superstore
    GROUP BY Category
)
SELECT
    Category,
    Total_Profit
FROM category_profit
ORDER BY Total_Profit DESC;

## RANK Categories by Profit

SELECT
    Category,
    SUM(Profit) AS Total_Profit,
    RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM superstore
GROUP BY Category;

## Rank Products by Profit

SELECT
    `Product Name`,
    SUM(Profit) AS Total_Profit,
    RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM superstore
GROUP BY `Product Name`;

## Top 3 Products Within Each Category

WITH product_profit AS (
    SELECT
        Category,
        `Product Name`,
        SUM(Profit) AS Total_Profit
    FROM superstore
    GROUP BY Category, `Product Name`
),
ranked_products AS (
    SELECT
        Category,
        `Product Name`,
        Total_Profit,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Profit DESC
        ) AS Product_Rank
    FROM product_profit
)
SELECT
    Category,
    `Product Name`,
    Total_Profit,
    Product_Rank
FROM ranked_products
WHERE Product_Rank <= 3
ORDER BY Category, Product_Rank;

## Year-over-Year Sales

WITH yearly_sales AS (
    SELECT
        YEAR(`Order Date`) AS Order_Year,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY YEAR(`Order Date`)
)
SELECT
    Order_Year,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Order_Year) AS Previous_Year_Sales,
    ROUND(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Order_Year))
        / LAG(Total_Sales) OVER (ORDER BY Order_Year) * 100,
        2
    ) AS YoY_Growth_Percent
FROM yearly_sales
ORDER BY Order_Year;

## Year-over-Year Profit

WITH yearly_profit AS (
    SELECT
        YEAR(`Order Date`) AS Order_Year,
        SUM(Profit) AS Total_Profit
    FROM superstore
    GROUP BY YEAR(`Order Date`)
)
SELECT
    Order_Year,
    Total_Profit,
    LAG(Total_Profit) OVER (ORDER BY Order_Year) AS Previous_Year_Profit,
    ROUND(
        (Total_Profit - LAG(Total_Profit) OVER (ORDER BY Order_Year))
        / NULLIF(LAG(Total_Profit) OVER (ORDER BY Order_Year), 0) * 100,
        2
    ) AS YoY_Growth_Percent
FROM yearly_profit
ORDER BY Order_Year;

## Monthly Sales with Previous Month

WITH monthly_sales AS (
    SELECT
        YEAR(`Order Date`) AS Order_Year,
        MONTH(`Order Date`) AS Order_Month,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY
        YEAR(`Order Date`),
        MONTH(`Order Date`)
)
SELECT
    Order_Year,
    Order_Month,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Sales
FROM monthly_sales
ORDER BY Order_Year, Order_Month;

## Running Total of Sales

WITH monthly_sales AS (
    SELECT
        YEAR(`Order Date`) AS Order_Year,
        MONTH(`Order Date`) AS Order_Month,
        SUM(Sales) AS Total_Sales
    FROM superstore
    GROUP BY
        YEAR(`Order Date`),
        MONTH(`Order Date`)
)
SELECT
    Order_Year,
    Order_Month,
    Total_Sales,
    SUM(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Running_Total_Sales
FROM monthly_sales
ORDER BY Order_Year, Order_Month;

## Rank Customers by Profit

SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Profit) AS Total_Profit,
    RANK() OVER (
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM superstore
GROUP BY
    `Customer ID`,
    `Customer Name`
ORDER BY Profit_Rank;

## Category Contribution to Total Sales

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    ROUND(
        SUM(Sales) / SUM(SUM(Sales)) OVER () * 100,
        2
    ) AS Sales_Contribution_Percent
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

## Category Contribution to Total Profit

SELECT
    Category,
    SUM(Profit) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(SUM(Profit)) OVER () * 100,
        2
    ) AS Profit_Contribution_Percent
FROM superstore
GROUP BY Category
ORDER BY Total_Profit DESC;

## Customers with Sales but Negative Profit

SELECT
    `Customer ID`,
    `Customer Name`,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY
    `Customer ID`,
    `Customer Name`
HAVING SUM(Sales) > 0
   AND SUM(Profit) < 0
ORDER BY Total_Profit ASC;

## Final Business Summary

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Discount) * 100, 2) AS Average_Discount_Percent,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS Profit_Margin_Percent
FROM superstore;

