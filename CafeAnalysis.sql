CREATE DATABASE CafeAnalysis;
GO

USE CafeAnalysis;

--1. fact_orders :

CREATE TABLE fact_orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    month VARCHAR(10),
    order_value INT,
    order_status VARCHAR(20),
    order_channel VARCHAR(20),
    source VARCHAR(20)
);

--2. dim_customers :

CREATE TABLE dim_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    join_date DATE,
    customer_type VARCHAR(20),
    total_orders INT,
    total_spent INT,
    retention_status VARCHAR(20)
);

--3. fact_daily_summary :

CREATE TABLE fact_daily_summary (
    date DATE,
    month VARCHAR(10),
    customers INT,
    revenue INT,
    orders INT
);

--4. fact_product_sales :

CREATE TABLE fact_product_sales (
    product_name VARCHAR(50),
    category VARCHAR(20),
    total_quantity INT,
    total_revenue INT,
    total_profit INT
);

--5. lead_source :

CREATE TABLE lead_source (
    source VARCHAR(50),
    total_orders INT
);

--5. order_stage :

CREATE TABLE order_stage (
    stage VARCHAR(50),
    count INT
);

--1. fact_orders :

INSERT INTO fact_orders VALUES
('ORD001','CUST001','2026-01-05','Jan',720,'Completed','Dine-in','Walk-in'),
('ORD002','CUST002','2026-01-10','Jan',1580,'Completed','Dine-in','Instagram'),
('ORD003','CUST001','2026-01-15','Jan',650,'Completed','Takeaway','Walk-in'),
('ORD004','CUST003','2026-01-20','Jan',900,'Completed','Dine-in','Referral'),
('ORD005','CUST004','2026-01-28','Jan',420,'Completed','Takeaway','Zomato'),

('ORD006','CUST003','2026-02-05','Feb',820,'Completed','Dine-in','Instagram'),
('ORD007','CUST005','2026-02-14','Feb',2200,'Completed','Dine-in','Walk-in'),
('ORD008','CUST002','2026-02-18','Feb',750,'Completed','Takeaway','Swiggy'),
('ORD009','CUST004','2026-02-20','Feb',950,'Cancelled','Takeaway','Zomato'),
('ORD010','CUST003','2026-02-27','Feb',500,'Completed','Dine-in','Walk-in'),

('ORD011','CUST005','2026-03-05','Mar',1100,'Completed','Dine-in','Walk-in'),
('ORD012','CUST001','2026-03-10','Mar',1250,'Completed','Dine-in','Instagram'),
('ORD013','CUST006','2026-03-15','Mar',2600,'Completed','Dine-in','Referral'),
('ORD014','CUST003','2026-03-20','Mar',850,'Completed','Takeaway','Swiggy'),
('ORD015','CUST002','2026-03-28','Mar',600,'Completed','Takeaway','Zomato');

--2. dim_customers :

INSERT INTO dim_customers VALUES
('CUST001','2026-01-01','Regular',5,3000,'Retained'),
('CUST002','2026-01-05','New',1,1580,'Churned'),
('CUST003','2026-02-10','Regular',3,4500,'Retained'),
('CUST004','2026-02-15','New',1,950,'Churned'),
('CUST005','2026-03-01','Premium',4,5200,'Retained'),
('CUST006','2026-03-10','New',1,600,'Churned');

--3. fact_daily_summary :

INSERT INTO fact_daily_summary VALUES
('2026-01-05','Jan',32,7200,28),
('2026-01-10','Jan',55,15800,48),
('2026-01-28','Jan',18,4200,15),
('2026-02-05','Feb',35,8200,30),
('2026-02-14','Feb',70,22000,60),
('2026-02-27','Feb',20,5000,18),
('2026-03-05','Mar',45,11000,38),
('2026-03-15','Mar',75,26000,65),
('2026-03-28','Mar',25,6000,20);

--4. fact_product_sales :

INSERT INTO fact_product_sales VALUES
('Cappuccino','Beverage',420,54600,33600),
('Oreo Frappe','Beverage',380,68400,38000),
('Veg Sandwich','Snacks',300,54000,30000),
('French Fries','Snacks',280,33600,16800),
('Chicken Burger','Fast Food',260,65000,33800),
('Chicken Pizza','Main',220,77000,37400),
('Chicken Biryani','Main',240,79200,36000),
('Brownie','Dessert',150,28500,18000);

--5. lead_source :

INSERT INTO lead_source VALUES
('Walk-in',400),
('Instagram',280),
('Zomato',220),
('Swiggy',180),
('Referral',150);

--6. order_stage :

INSERT INTO order_stage VALUES
('New',120),
('Preparing',300),
('Served',450),
('Cancelled',110);

SELECT * FROM fact_orders ;
SELECT * FROM dim_customers;
SELECT * FROM fact_daily_summary;
SELECT * FROM fact_product_sales;
SELECT * FROM lead_source;
SELECT * FROM order_stage;

--1.Total Revenue (core KPI) :

SELECT SUM(order_value) AS total_revenue
FROM fact_orders
WHERE order_status = 'Completed';

--2. Monthly Revenue Trend :

SELECT month, SUM(order_value) AS revenue
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY month
ORDER BY month;

--3. Conversion Rate (important KPI) :

SELECT 
CAST(
SUM(CASE WHEN order_status='Completed' THEN 1 ELSE 0 END) * 100.0 
/ COUNT(*) 
AS DECIMAL(5,2)
) AS conversion_rate
FROM fact_orders;

--4. Revenue by Source (business insight) :

SELECT source, SUM(order_value) AS revenue
FROM fact_orders
WHERE order_status='Completed'
GROUP BY source
ORDER BY revenue DESC;

--5. Top Customers :

SELECT TOP 3 customer_id, SUM(order_value) AS total_spent
FROM fact_orders
WHERE order_status='Completed'
GROUP BY customer_id
ORDER BY total_spent DESC;

--6. Weekend vs Weekday (simple logic) :

SELECT 
DATENAME(WEEKDAY, order_date) AS day_name,
SUM(order_value) AS revenue
FROM fact_orders
WHERE order_status='Completed'
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY revenue DESC;