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

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Retrieve all books in the "Fiction" genre:

Select * from Books
where genre='Fiction';

-- Find books published after the year 1950:

Select * from Books 
where published_year>1950;

-- List all customers from the Canada:

Select * from customers
where country ='Canada';

-- Show orders placed in November 2023:
Select * from Orders
WHERE order_date between '2023-11-01' and '2023-11-30';

-- Retrieve the total stock of books available:

Select sum(stock) as total_stock from books;

-- Find the details of the most expensive book:
Select * from Books
order by Price desc
Limit 1;

--Show all customers who ordered more than 1 quantity of a book

Select * from orders
where quantity>1;

-- Retrieve all orders where the total amount exceeds $20:

Select *from orders
where total_amount > 20;

-- List all genres available in the Books table:

Select DISTINCT genre from Books;

-- Find the book with the lowest stock:

Select * from books
order by stock ASC
LIMIT 1;

-- Calculate the total revenue generated from all orders

Select sum(total_amount) as total_revenue from orders;

-- Retrieve the total number of books sold for each genre:

Select books.genre,sum(orders.quantity) as total_sold from orders join books
on books.book_id=orders.book_id
Group by books.genre;

-- Find the average price of books in the "Fantasy" genre

Select avg(price) as avg_price from books
where genre='Fantasy';

--List customers who have placed at least 2 orders

Select orders.customer_id,customers.name,count(orders.order_id) as total_count from orders 
join customers on orders.customer_id= customers.customer_id
group by orders.customer_id, customers.name
having count(order_id)>=2;

--Find the most frequently ordered book

Select o.book_id,b.title, count(o.order_id) as total_count from orders o
join books b 
on o.book_id= b.book_id
group by o.book_id, b.title
order by total_count DESC
LIMIT 1;

--Show the top 3 most expensive books of 'Fantasy' Genre 

Select title,price from books
where genre= 'Fantasy'
order by price DESC
LIMIT 3

-- Retrieve the total quantity of books sold by each author

Select b.author,sum(o.quantity) as total from orders o 
join books b
on o.book_id = b.book_id
group by b.author

-- List the cities where customers who spent over $30 are located

select DISTINCT c.city,o.total_amount 
from customers c
JOIN orders o ON c.customer_id= o.customer_id
where (o.total_amount)> 30;

-- Find the customer who spent the most on orders

Select c.name, sum(o.total_amount) as T from customers c
JOIN orders o 
ON c.customer_id = o.customer_id
Group by c.name
order by T DESC
LIMIT 1;

-- Calculate the stock remaining after fulfilling all orders

Select b.book_id, b.title,b.stock,COALESCE(SUM(o.quantity),0) as ord_qty,
      b.stock- COALESCE(SUM(O.quantity),0) as rem_qty
from books b
LEFT JOIN orders o 
ON b.book_id= o.book_id 
group by b.book_id
order by b.book_id;



















