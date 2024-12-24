Zomato Data Analysis using SQL

Project Overview

This project focuses on analyzing a simulated Zomato-like food delivery database to derive business insights and optimize operations using SQL.

Key Objectives

Database Design: Structuring tables and relationships for customers, restaurants, menu items, orders, deliveries, and riders.

CRUD Operations: Performing basic Create, Read, Update, and Delete tasks.

Business Queries: Solving real-world business problems with advanced SQL queries.

Insights & Reporting: Providing actionable insights for stakeholders.

Dataset Description

The database consists of the following tables:

Customers:

Stores customer details like customer_id, name, email, phone_number, city, and registration_date.

Restaurants:

Includes restaurant details like restaurant_id, name, city, and cuisine.

Menu_Items:

Represents dishes available at restaurants with fields like menu_item_id, restaurant_id, dish_name, and price.

Orders:

Tracks order data, including order_id, customer_id, restaurant_id, order_date, and total_amount.

Deliveries:

Links orders to delivery status with delivery_id, order_id, rider_id, and delivery_time.

Riders:

Contains details of delivery personnel such as rider_id, name, and phone_number.

ER Diagram

The following Entity-Relationship Diagram illustrates the relationships between the entities:

(Diagram placeholder: Visualize relationships among Customers, Restaurants, Menu_Items, Orders, Deliveries, and Riders.)

SQL Query Highlights

1. Top 5 Dishes Ordered by a Specific Customer

Find the most frequently ordered dishes by a customer in the last year.

SELECT 
    mi.dish_name, 
    COUNT(o.order_id) AS order_count
FROM orders o
JOIN menu_items mi ON o.restaurant_id = mi.restaurant_id
WHERE o.customer_id = (SELECT customer_id FROM customers WHERE name = 'Arjun Mehta')
  AND o.order_date >= NOW() - INTERVAL 1 YEAR
GROUP BY mi.dish_name
ORDER BY order_count DESC
LIMIT 5;

2. Popular Order Time Slots

Analyze the hours when the highest number of orders are placed.

SELECT 
    HOUR(order_date) AS order_hour, 
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC;

3. High-Value Customers

Identify customers who have spent over $10,000.

SELECT 
    c.name AS customer_name, 
    SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING total_spent > 10000
ORDER BY total_spent DESC;

4. Restaurant Revenue Rankings

Rank restaurants by the total revenue generated.

SELECT 
    r.name AS restaurant_name, 
    SUM(o.total_amount) AS revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id
ORDER BY revenue DESC;

5. Orders Without Deliveries

Detect orders that were not delivered.

SELECT 
    o.order_id, 
    c.name AS customer_name, 
    r.name AS restaurant_name
FROM orders o
LEFT JOIN deliveries d ON o.order_id = d.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE d.delivery_id IS NULL;

6. Most Active Riders

Find the top 3 riders based on the number of deliveries completed.

SELECT 
    r.name AS rider_name, 
    COUNT(d.delivery_id) AS total_deliveries
FROM deliveries d
JOIN riders r ON d.rider_id = r.rider_id
GROUP BY r.rider_id
ORDER BY total_deliveries DESC
LIMIT 3;

7. Riders Generating the Most Revenue

Identify riders contributing the most to revenue by completing deliveries.

SELECT 
    r.name AS rider_name, 
    SUM(o.total_amount) AS total_revenue
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN riders r ON d.rider_id = r.rider_id
GROUP BY r.rider_id
ORDER BY total_revenue DESC;

Insights and Business Recommendations

Popular Dishes:

The most ordered dishes can guide restaurant menu adjustments.

Peak Order Times:

Use this information to optimize staffing and delivery resources during busy hours.

High-Value Customers:

Implement loyalty programs to retain high-value customers.

Restaurant Performance:

Encourage partnerships with top-performing restaurants.

Delivery Insights:

Optimize delivery operations by addressing undelivered orders and rewarding high-performing riders.

Conclusion

This project demonstrates the effective use of SQL for data analysis in a food delivery platform context. By solving practical business challenges, it provides a foundation for making data-driven decisions to improve customer satisfaction, operational efficiency, and revenue growth.
