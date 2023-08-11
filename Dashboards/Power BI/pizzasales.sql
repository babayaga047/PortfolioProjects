SELECT*
FROM pizza_sales

--Total Revenue
SELECT SUM(total_price) AS TotalRevenue
FROM pizza_sales

--Average order value
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS AvgOrderVal
FROM pizza_sales

--Total pizzas sold
SELECT SUM(quantity) AS TotalPizzaSold
FROM pizza_sales

--Total Orders Placed
SELECT COUNT(DISTINCT order_id) AS TotalOrdersPlaced
FROM pizza_sales

--Average pizzas per order
SELECT CAST(SUM(quantity) AS DECIMAL(10,2))/CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS AvgOrders
FROM pizza_sales

--Daily, Monthly trend of orders
SELECT DATENAME(DW, order_date) AS OrderDay, COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY TotalOrders desc

SELECT DATENAME(MONTH, order_date) AS OrderMonth, COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY TotalOrders desc

--Percentage of sales by pizza category, size
SELECT pizza_category, SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales)*100 AS PercentOfTotalSales
FROM pizza_sales
GROUP BY pizza_category

SELECT pizza_size, SUM(total_price) AS TotalPriceSizeWise, SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(quarter, order_date)=1)*100 AS PercentOfTotalSales
FROM pizza_sales
WHERE DATEPART(quarter, order_date)=1
GROUP BY pizza_size
ORDER BY PercentOfTotalSales desc

--Top 5 and bottom 5 sellers by revenue, quantity, orders
SELECT TOP 5 pizza_name, SUM(total_price) AS Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Revenue asc/desc

SELECT TOP 5 pizza_name, SUM(quantity) AS Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Quantity desc

SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Orders asc




