-- Create Database
CREATE DATABASE OnlineBookstore;
show databases;
use OnlineBookstore;


-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
ALTER TABLE orders
ADD COLUMN orders_Date_Formatted DATE;

UPDATE orders
SET 
  orders_Date_Formatted = STR_TO_DATE(order_Date, '%d-%m-%Y');  
  
ALTER TABLE orders
DROP COLUMN order_Date;


ALTER TABLE orders
RENAME COLUMN orders_Date_Formatted TO order_Date;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where Genre = "Fiction";



-- 2) Find books published after the year 1950:
select * from books
where Published_year>1950;


-- 3) List all customers from the Canada:
select * from customers
where country="Canada";


-- 4) Show orders placed in November 2023:
select * from orders 
where Order_Date between '2023-11-01' AND '2023-11-30' ;




-- 5) Retrieve the total stock of books available:
Select sum(Stock) as total_Stock
from books;

-- 6) Find the details of the most expensive book:

select * from books
order by  Price desc 
limit 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders 
where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * from orders 
where total_amount>20;

-- 9) List all genres available in the Books table:
select distinct Genre from books;

-- 10) Find the book with the lowest stock:
select * from books
order by Stock 
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(Total_Amount) as Total_revenue
from orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select b.Genre , sum(o.Quantity) as book_sold
from books b
join orders o
on b.book_id= o.book_id
group by b.Genre;



-- 2) Find the average price of books in the "Fantasy" genre:
select genre , avg(price) as avg_price
from books
where genre="Fantasy";



-- 3) List customers who have placed at least 2 orders:
select c.name,o.customer_id ,count(o.order_id) as order_count
from orders o
join customers c
on c.customer_id = o.customer_id
group by customer_id
having count(o.order_id)>=2;



-- 4) Find the most frequently ordered book:
select b.book_id,b.Title ,count(o.order_id) as order_count
from books b
join orders o 
on b.book_id = o.book_id
group by b.book_id
order by order_count desc
limit 1;




-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select Genre , price
from books
where genre = "Fantasy"
-- group  by genre
order by price
limit 3;




-- 6) Retrieve the total quantity of books sold by each author:
select b.author , sum(o.quantity) as total_quantity
from books b
join orders o
on b.book_id = o.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city,total_amount
from orders o
join customers c 
on o.customer_id=c.customer_id
where o.total_amount>30;

-- 8) Find the customer who spent the most on orders:
select c.customer_id,c.name, sum(o.Total_amount) as total_spent
from orders o
join customers c on o.customer_id= c.customer_id
group by c.customer_id , c.name
order by total_spent desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
select b.book_id,b.title,b.stock , coalesce(sum(quantity),0) as order_quantity , b.stock-coalesce(sum(quantity),0) as remaining_quantity
from books b
left join orders o 
on b.book_id = o.book_id
group by b.book_id;







