create database Amazon;
select * from amazon_sales;
-- Modifying the column(data type of column) 

alter table amazon_sales
modify  column `Branch` varchar(5) not null,  
modify  column City varchar(30) not null
;

 alter table amazon_sales
 modify column customer_type varchar(30) not null
 ;
 
 alter table amazon_sales
 modify column gender varchar(10),
 change column `Product line` `product_line` varchar(100)
 ;
 alter table amazon_sales
 modify column gender varchar(10) not null,
 modify column `product_line` varchar(100) not null;
 
 alter table amazon_sales
modify column Total decimal(10,2) not null,
modify column `Date` date not null,
modify column `Time` Time not null,
modify column cogs decimal(10,2)not null
;

alter table amazon_sales
modify column Rating Decimal(10,1) not null;
 
 -- Changing the column name 
 alter table amazon_sales
 change  column `Invoice ID` `Invoice_ID` varchar(30) not null primary key ;
 
 alter table amazon_sales
 change column `Unit price` `Unit_price` decimal(10,2) not null
 ;
 
 alter table amazon_sales
 change column `Payment` `Payment_method` varchar(30)not null;
 
 alter table amazon_sales
 change column `Tax 5%` `VAT` float(6,4) not null,
 change column `gross margin percentage` `Gross_margin_percentage` float(11,9)not null,
 change column `gross inCome` `Gross_income` decimal(10,2)not null;
 --
select * from amazon_sales;

select * from amazon_sales;


-- add column Timeofday,dayname,monthname

ALTER TABLE amazon_sales
ADD COLUMN timeofday VARCHAR(20),
ADD COLUMN dayname VARCHAR(10),
ADD COLUMN monthname VARCHAR(10);

-- diving A day into 3 slots Morining ,Evening,AfterNoon 
UPDATE amazon_sales
SET timeofday = CASE
    WHEN HOUR(`time`) < 12 THEN 'Morning'
    WHEN HOUR(`time`) >= 12 AND HOUR(`time`) < 18 THEN 'Afternoon'
    ELSE 'Evening'
END;

-- giving Name to day 
UPDATE amazon_sales
SET dayname = DAYNAME(`date`);

-- Giving month Name
UPDATE amazon_sales
SET monthname = MONTHNAME(`date`);

select * from amazon_sales;
-- 1. What is the count of distinct cities in the dataset?

SELECT COUNT(DISTINCT city) AS distinct_cities FROM amazon_sales;

--  2. For each branch, what is the corresponding city?

SELECT DISTINCT branch, city FROM amazon_sales;
-- 3. What is the count of distinct product lines in the dataset?

SELECT COUNT(DISTINCT product_line) AS distinct_product_lines FROM amazon_sales;

-- 4. Which payment method occurs most frequently?

SELECT payment_method, COUNT(*) AS count
FROM amazon_sales
GROUP BY payment_method
ORDER BY count DESC
;
-- 5. Which product line has the highest sales?

SELECT product_line, SUM(total) AS total_sales
FROM amazon_sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

-- 6. How much revenue is generated each month?

SELECT monthname, SUM(total) AS revenue
FROM amazon_sales
GROUP BY monthname
ORDER BY revenue desc;
-- 7. which month did the cost of goods sold reach its peak?

SELECT monthname, SUM(cogs) AS total_cogs
FROM amazon_sales
GROUP BY monthname
ORDER BY total_cogs DESC
;

-- 8. Which product line generated the highest revenue?

SELECT product_line, SUM(total) AS revenue
FROM amazon_sales
GROUP BY product_line
ORDER BY revenue DESC
LIMIT 1;

-- 9. In which city was the highest revenue recorded?

SELECT city, SUM(total) AS revenue
FROM amazon_sales
GROUP BY city
ORDER BY revenue DESC
;

-- 10. Which product line incurred the highest Value Added Tax?

SELECT product_line, SUM(VAT) AS total_vat
FROM amazon_sales
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

SELECT product_line,
       SUM(total) AS total_sales,
       CASE 
           WHEN SUM(total) > (SELECT AVG(total_sales) FROM (
               SELECT product_line, SUM(total) AS total_sales
               FROM amazon_sales
               GROUP BY product_line
           ) AS avg_table)
           THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM amazon_sales
GROUP BY product_line;


-- 12. Identify the branch that exceeded the average number of products sold.
SELECT branch, SUM(quantity) AS total_quantity
FROM amazon_sales
GROUP BY branch
HAVING total_quantity > (
    SELECT AVG(q) FROM (
        SELECT SUM(quantity) AS q
        FROM amazon_sales
        GROUP BY branch
    ) AS avg_branch
);

-- 13. Which product line is most frequently associated with each gender?

SELECT gender, product_line, COUNT(*) AS count
FROM amazon_sales
GROUP BY gender, product_line
HAVING count = (
    SELECT MAX(sub.count)
    FROM (
        SELECT gender AS g, product_line AS p, COUNT(*) AS count
        FROM amazon_sales
        GROUP BY gender, product_line
    ) AS sub
    WHERE sub.g = amazon_sales.gender
)
ORDER BY gender;

-- 14. Calculate the average rating for each product line.

SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales
GROUP BY product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.

SELECT dayname, timeofday, COUNT(*) AS sale_count
FROM amazon_sales
GROUP BY dayname, timeofday
ORDER BY FIELD(dayname, 'Monday','Tueday','Wedday','Thuday','Friday','Satday','Sunday');


-- 16. Identify the customer type contributing the highest revenue.

SELECT customer_type, SUM(total) AS revenue
FROM amazon_sales
GROUP BY customer_type
ORDER BY revenue DESC
LIMIT 1;

-- 17. Determine the city with the highest VAT percentage.

SELECT city, AVG(VAT / total * 100) AS avg_vat_percent
FROM amazon_sales
GROUP BY city
ORDER BY avg_vat_percent DESC
LIMIT 3;

--  18. Identify the customer type with the highest VAT payments.

SELECT customer_type, SUM(VAT) AS total_vat
FROM amazon_sales
GROUP BY customer_type
ORDER BY total_vat DESC
;

-- 19. What is the count of distinct customer types in the dataset?

SELECT COUNT(DISTINCT customer_type) AS customer_type_count FROM amazon_sales;

-- 20. What is the count of distinct payment methods in the dataset?

SELECT COUNT(DISTINCT payment_method) AS payment_method_count FROM amazon_sales;

-- 21. Which customer type occurs most frequently?

SELECT customer_type, COUNT(*) AS count
FROM amazon_sales
GROUP BY customer_type
ORDER BY count DESC
limit 1
;

-- 22. Identify the customer type with the highest purchase frequency.

SELECT customer_type, COUNT(*) AS purchase_count
FROM amazon_sales
GROUP BY customer_type
ORDER BY purchase_count DESC
LIMIT 1;

-- 23. Determine the predominant gender among customers.

SELECT gender, COUNT(*) AS count
FROM amazon_sales
GROUP BY gender
ORDER BY count DESC
LIMIT 2;

-- 24. Examine the distribution of genders within each branch.

SELECT branch, gender, COUNT(*) AS gender_count
FROM amazon_sales
GROUP BY branch, gender
ORDER BY branch;

-- 25. Identify the time of day when customers provide the most ratings.

SELECT timeofday, COUNT(rating) AS rating_count
FROM amazon_sales
GROUP BY timeofday
ORDER BY rating_count DESC
LIMIT 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.

SELECT branch, timeofday, avg(rating) AS avg_rating
FROM amazon_sales
GROUP BY branch, timeofday
ORDER BY branch, avg_rating DESC;

-- 27. Identify the day of the week with the highest average ratings.

SELECT dayname, AVG(rating) AS avg_rating
FROM amazon_sales
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1; 


-- -- 28. Determine the day of the week with the highest average ratings for each branch.
SELECT branch, dayname, avg_rating
FROM (
    SELECT branch, dayname, ROUND(AVG(rating), 2) AS avg_rating,
           RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rating_rank
    FROM amazon_sales
    GROUP BY branch, dayname
) AS ranked_days
WHERE rating_rank = 1;
