create database zomato_analysis;
use zomato_analysis;


-- In this Zomato data analysis project, we aim to explore and 
-- derive insights from a dataset comprising restaurant information, 
-- including details such as location, cuisine, pricing, 
-- and customer reviews. We will examine factors influencing 
-- restaurant popularity, assess the relationship between 
-- price and customer ratings, and investigate the prevalence 
-- of services like online delivery and table booking. 
--  The project seeks to provide valuable insights into the restaurant 
--  industry and enhance decision-making for both customers and 
--  restaurateurs

-- task 1 >> import data


-- NOTE >> only CSV or JSON files can be importes in SQL
--  Description of the dataset:

-- RestaurantID: A unique identifier for each restaurant in the dataset.

-- RestaurantName: The name of the restaurant.

-- CountryCode: A code indicating the country where the restaurant 
-- is located.

-- City: The city in which the restaurant is situated.

-- Address: The specific address of the restaurant.

-- Locality: The locality (neighborhood or district) where the restaurant 
-- is located.

-- LocalityVerbose: A more detailed description or name of the locality.

-- Longitude: The geographical longitude coordinate of the restaurant's 
-- location.

-- Latitude: The geographical latitude coordinate of the restaurant's 
-- location.

-- Cuisines: The types of cuisines or food offerings available at the 
-- restaurant. This may include multiple cuisines separated by commas.

-- Currency: The currency used for pricing in the restaurant.

-- Has_Table_booking: A binary indicator (0 or 1) that shows whether 
-- the restaurant offers table booking.

-- Has_Online_delivery: A binary indicator (0 or 1) that shows 
-- whether the restaurant provides online delivery services.

-- Is_delivering_now: A binary indicator (0 or 1) that indicates 
-- whether the restaurant is currently delivering food.

-- Switch_to_order_menu: A field that might suggest whether customers 
-- can switch to an online menu to place orders.

-- Price_range: A rating or category that indicates the price 
-- range of the restaurant's offerings (e.g., low, medium, high).

-- Votes: The number of votes or reviews that the restaurant has received.

-- Average_Cost_for_two: The average cost for two people to dine 
-- at the restaurant, often used as a measure of affordability.

-- Rating: The rating of the restaurant, possibly on a scale 
-- from 0 to 5 or a similar rating system.

-- Datekey_Opening: The date or key representing the restaurant's 
-- opening date.


SHOW tables;

-- DESCRIBE both tables to understand them >>

DESC rest_data;
DESC country_data;


SELECT * FROM rest_data;
SELECT * FROM country_data;


-- task 2 >> DATA CLEANING >>

-- 2.1) country_data table >> convert column name "country name" to "country_name"

-- every time we have to write column name like this as shown below
-- which is very uncomfortable so rename column name

SELECT `country name` FROM country_data; 

ALTER TABLE country_data
RENAME COLUMN `country name` TO country_name;

SELECT country_name FROM country_data;

DESC country_data;


-- 2.2) datekey_opening >> contains date but have datatype as TEXT
-- convert the column to DATE and replace value format from
-- "2019_05_29" to 2019/05/29

 SELECT datekey_opening FROM rest_data;
 SET SQL_SAFE_UPDATES = 0; -- to update whole column values without WHERE clause
 
UPDATE rest_data SET datekey_opening = replace(datekey_opening,'-','/') ;
SELECT datekey_opening FROM rest_data;
  
 ALTER TABLE rest_data
 MODIFY COLUMN datekey_opening DATE; -- changed datatype from TEXT from DATE

 
 SET SQL_SAFE_UPDATES = 1;
 
 
 
 -- task 3 >> check unique values from categorical columns
 
SELECT DISTINCT countrycode FROM rest_data;
SELECT DISTINCT has_online_delivery FROM rest_data; 
SELECT DISTINCT has_table_booking FROM rest_data;
SELECT DISTINCT price_range FROM rest_data;
SELECT DISTINCT rating FROM rest_data;
SELECT DISTINCT is_delivering_now FROM rest_data;


-- task 4 >> find number of restaurants

SELECT COUNT(DISTINCT(restaurantid)) FROM rest_data;

# Total data is availabel for 9551 restaurants


-- task 5 >> country count 

SELECT COUNT(countryid) country_count FROM country_data;

-- total 15 countries data is availabel

-- task 6 >> country name

SELECT country_name FROM country_data;


-- task 7 >> country wise count of restaurants and percent of total restaurants 

SELECT c1.country_name,COUNT(r1.restaurantid) tot_rest, 
COUNT(r1.restaurantid)/(SELECT COUNT(restaurantid) FROM rest_data) * 100
FROM country_data c1 INNER JOIN rest_data r1
ON c1.countryid = r1.countrycode
GROUP BY c1.country_name
ORDER BY tot_rest DESC;

-- 90% of total restaurants are from india only


-- task 8 >> percentage of restaurants based on "Has_Online_Delivery"

SELECT COUNT(restaurantid) online_del,
COUNT(restaurantid)/(SELECT COUNT(restaurantid) FROM rest_data) * 100 tot_online_per
FROM rest_data 
GROUP BY Has_Online_Delivery;


-- 25.66%  Has_Table_Booking
-- but remaining 74.34% restaurants does NOT HAVE online delivery option


-- task 9 >> percentage of restaurants based on "Has_Table_Booking"

SELECT COUNT(restaurantid) online_del,
COUNT(restaurantid)/(SELECT COUNT(restaurantid) FROM rest_data) * 100 tot_online_per
FROM rest_data 
GROUP BY Has_Table_Booking;

-- 87.87% Has_Table_Booking remaining 12.12% DOES NOT HAVE Table_Booking

 
 -- task 10 >> top 5 restaurants with country name who has most number of votes >>
 
 SELECT r1.restaurantid,r1.restaurantname,votes,c1.country_name FROM 
 country_data c1 INNER JOIN rest_data r1
 ON c1.countryid = r1.countrycode
 
 ORDER BY r1.votes DESC
 LIMIT 5;
 
 
 -- task 11 >> find most common cuisines from database
 
 SELECT cuisines,count(cuisines) cuis_count FROM rest_data
 GROUP BY cuisines
 ORDER BY cuis_count DESC;
 
 -- North Indian is the most common cuisine in dataset
 
 
 -- task 12 Number of restaurants opening based on Year,Quarter,Month
 
-- Year wise restaurant opening
 
 SELECT YEAR(datekey_opening) open_year ,count(restaurantid) tot_rest
 FROM rest_data
 GROUP BY open_year
 ORDER BY open_year ASC;
 
 -- Month wise restaurant opening
 
SELECT MONTHNAME(datekey_opening) open_month ,count(restaurantid) tot_rest
FROM rest_data
GROUP BY open_month, MONTH(datekey_opening)
ORDER BY MONTH(datekey_opening) ASC;

 -- Quarter wise restaurant opening
 
 SELECT QUARTER(datekey_opening) open_quart ,count(restaurantid) tot_rest
FROM rest_data
GROUP BY open_quart
ORDER BY open_quart ASC;

