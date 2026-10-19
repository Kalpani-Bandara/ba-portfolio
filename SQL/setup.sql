-- Setup script for superstore_db
-- Source: Superstore.csv, cleaned in Excel (1 duplicate removed, 9,993 rows)
-- Do NOT re-run if the tables already exist.

CREATE DATABASE superstore_db;
USE superstore_db;

-- Step 1: staging table orders_raw was loaded from the cleaned CSV
-- using: LOAD DATA INFILE '.../superstore_clean.csv' INTO TABLE orders_raw
--        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
--        LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
-- Check: 9,993 rows, total sales 2,296,919 (matches the Excel pivot).

-- Step 2: one row per customer
CREATE TABLE customers (
  customer_id   VARCHAR(20) PRIMARY KEY,
  customer_name VARCHAR(100),
  segment       VARCHAR(30)
);
INSERT INTO customers
SELECT DISTINCT `Customer ID`, `Customer Name`, Segment FROM orders_raw;

-- Step 3: one row per product (32 product IDs had two name variants; one is kept)
CREATE TABLE products (
  product_id   VARCHAR(30) PRIMARY KEY,
  product_name VARCHAR(255),
  category     VARCHAR(30),
  sub_category VARCHAR(30)
);
INSERT INTO products
SELECT `Product ID`, MIN(`Product Name`), MIN(Category), MIN(`Sub-Category`)
FROM orders_raw GROUP BY `Product ID`;

-- Step 4: one row per order line, with real dates and 5-digit ZIP codes
CREATE TABLE orders (
  row_id INT PRIMARY KEY, order_id VARCHAR(20),
  order_date DATE, ship_date DATE, ship_mode VARCHAR(20),
  customer_id VARCHAR(20), product_id VARCHAR(30),
  city VARCHAR(60), state VARCHAR(40), postal_code CHAR(5), region VARCHAR(20),
  sales DECIMAL(12,4), quantity INT, discount DECIMAL(4,2), profit DECIMAL(12,4),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id)  REFERENCES products(product_id)
);
INSERT INTO orders
SELECT `Row ID`, `Order ID`, STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
       STR_TO_DATE(`Ship Date`, '%m/%d/%Y'), `Ship Mode`, `Customer ID`,
       `Product ID`, City, State, LPAD(`Postal Code`, 5, '0'), Region,
       Sales, Quantity, Discount, Profit
FROM orders_raw;