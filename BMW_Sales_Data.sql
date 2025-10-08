CREATE TABLE bmw_sales(
      Model VARCHAR(50),
	  Year INT,
	  Region VARCHAR(50),
	  Color VARCHAR(20),
	  Fuel_Type VARCHAR(20),
	  Transmission VARCHAR(20),
	  Engine_Size_L DECIMAL(3,1),
	  Mileage_KM INT,
	  Price_USD INT,
	  Sales_Volume INT,
	  Sales_Classification VARCHAR(20)
	  
);

SELECT * FROM bmw_sales;

SELECT * FROM bmw_sales LIMIT 10;

SELECT MIN(Year), MAX(YEAR) FROM bmw_sales

SELECT DISTINCT Model FROM bmw_sales

SELECT DISTINCT Region FROM bmw_sales

SELECT DISTINCT Fuel_Type FROM bmw_sales

-- 1. Total Sales by Year

SELECT Year,SUM(sales_volume) AS Total_Sales 
FROM bmw_sales
GROUP BY Year
ORDER BY Year;

-- 2. Best-Selling Model

SELECT Model,SUM(sales_volume) AS total_sales
FROM bmw_sales
GROUP BY Model
ORDER BY total_sales
LIMIT 5;

--3. Sales by region

SELECT region,SUM(sales_volume) AS total_sales
FROM bmw_sales
GROUP BY region
Order by total_sales DESC;

--4. Fuel Type Trend

SELECT Year, Fuel_Type, SUM(sales_volume) AS total_sales
FROM bmw_sales
GROUP BY Year,Fuel_Type
ORDER BY Year, total_sales DESC;

--5. Average price per model

SELECT Model,ROUND(AVG(Price_USD),2) AS avg_price
FROM bmw_sales
GROUP BY Model
ORDER BY avg_price DESC;

--6. Year-over-Year-Growth

WITH Yearly_sales AS(
     SELECT Year,SUM(sales_volume) AS total_sales
	 FROM bmw_sales
	 GROUP BY Year
)
SELECT Year,
       total_sales,
	   LAG(total_sales) OVER(Order by Year) AS Prev_Year_Sales,
	   ROUND((total_sales - LAG(total_Sales) OVER(order by Year))::NUMERIC /
	        LAG(total_sales)OVER(Order by Year) * 100, 2) AS yoy_growth_percent
	   FROM Yearly_sales;	
	   


--7. Top Model in each region

WITH ranked_models AS (
    SELECT 
        Region,
        Model,
        SUM(Sales_Volume) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales_Volume) DESC) AS rn
    FROM bmw_sales
    GROUP BY Region, Model
)
SELECT Region, Model, total_sales
FROM ranked_models
WHERE rn = 1
ORDER BY Region;
