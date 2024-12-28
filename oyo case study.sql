/*

Business objective:
1. Identify customer segments based on booking patterns, spending behaviour to create targeted marketing campaigns
2. Analyze booking trends and discount patterns to optimize pricing strategies for different cities
3. Assess booking patterns to improve operational efficiency such as hotel staffing, resource management


Key Metrics for each questions:
1.a. Average amount spent per booking for each customer, C
1.b. Frequency of bookings and cancellation rate for each customer
2.a. Average booking amount per city
2.b  Average discounts across cities peak versus off-season demand across cities
3.a. Average length of stay, seasonal demand patterns (Monthly/Quaterly stay patterns)

*/


CREATE DATABASE Oyo;
USE Oyo;

SELECT COUNT(hotel_id) FROM oyo_city;

SELECT COUNT(booking_id) FROM oyo_sales;

ALTER TABLE oyo_sales
ADD COLUMN price float;

SET SQL_SAFE_UPDATES = 0;

UPDATE oyo_sales
SET price = amount = discount;

ALTER TABLE oyo_sales
ADD COLUMN duration INT;

UPDATE oyo_sales
SET check_in = STR_TO_DATE(check_in, '%d-%m-%Y');

UPDATE oyo_sales
SET check_out = STR_TO_DATE(check_out, '%d-%m-%Y');

UPDATE oyo_sales
SET duration = DATEDIFF(check_out, check_in);

ALTER TABLE oyo_sales
ADD COLUMN rate INT;

UPDATE oyo_sales
SET rate = ROUND(
CASE 
WHEN no_of_rooms = 1 THEN price/duration
WHEN no_of_rooms != 1 THEN (price/duration)/no_of_rooms
ELSE 0
END);

SELECT * FROM oyo_sales;

-- 1.a. Average amount spent per booking for each customer, C

SELECT customer_id, AVG(amount) AS avg_spending
FROM oyo_sales
GROUP BY customer_id
ORDER BY avg_spending DESC;

-- 1.b. Frequency of bookings and cancellation rate for each customer
SELECT customer_id, 
	COUNT(booking_id) AS booking_frquency, 
	COUNT(IF(status = 'Cancelled',1,NULL)) AS cancelled_booking,
CASE
WHEN COUNT(status) = 0 THEN 0
ELSE COUNT(IF(status = 'Cancelled',1,NULL)) / COUNT(status)
END AS cancelled_rate
FROM oyo_sales
GROUP BY customer_id;

-- 2.a. Average booking amount per city
SELECT customer_id, AVG(amount) AS avg_booking
FROM oyo_sales
GROUP BY customer_id
ORDER BY avg_booking DESC;

-- 2.b  Average discounts across cities peak versus off-season demand across cities
SELECT customer_id, AVG(discount) AS avg_booking
FROM oyo_sales
GROUP BY customer_id
ORDER BY avg_booking DESC;

-- 3.a. Average length of stay, seasonal demand patterns (Monthly/Quaterly stay patterns)
SELECT AVG(duration)
FROM oyo_sales;