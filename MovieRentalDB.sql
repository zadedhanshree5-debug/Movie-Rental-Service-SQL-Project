DROP DATABASE MovieRentalDB;

CREATE DATABASE MovieRentalDB;

USE MovieRentalDB;

-- Create table into movies-- 

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    genre VARCHAR(50),
    rental_rate DECIMAL(5,2)
);

-- Create table into customers--  

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15),
    membership_date DATE
);

-- Create table into rentals-- 

CREATE TABLE rentals (
    rental_id INT PRIMARY KEY,
    customer_id INT,
    movie_id INT,
    rental_date DATE,
    return_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Create table into payments-- 

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    rental_id INT,
    payment_date DATE,
    amount DECIMAL(6,2),
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);

-- Inserting values into movies-- 

INSERT INTO movies VALUES
(1,'Inception',2010,'Sci-Fi',120.00),
(2,'Avatar',2009,'Fantasy',150.00),
(3,'Titanic',1997,'Romance',100.00),
(4,'Avengers',2012,'Action',130.00),
(5,'Joker',2019,'Drama',110.00),
(6,'Frozen',2013,'Animation',90.00),
(7,'Interstellar',2014,'Sci-Fi',140.00),
(8,'Gladiator',2000,'Action',95.00),
(9,'Coco',2017,'Animation',85.00),
(10,'Matrix',1999,'Sci-Fi',105.00),
(11,'Harry Potter',2001,'Fantasy',135);

-- Inserting values into customers-- 

INSERT INTO customers VALUES
(1,'Rahul Sharma','9876543210','2023-01-10'),
(2,'Anita Desai','9876543222','2023-02-15'),
(3,'Rohit Verma','9876543233','2023-03-01'),
(4,'Sneha Patil','9876543244','2023-04-05'),
(5,'Amit Joshi','9876543255','2023-05-10'),
(6,'Neha Singh','9876543266','2023-06-01'),
(7,'Karan Mehta','9876543277','2023-07-20'),
(8,'Pooja Kulkarni','9876543288','2023-08-15'),
(9,'Vikas Rao','9876543299','2023-09-01'),
(10,'Ritu Malhotra','9876543300','2023-10-10');

-- Inserting values into rentals-- 
INSERT INTO rentals VALUES
(1,1,1,'2024-01-01','2024-01-05'),
(2,2,2,'2024-01-03',NULL),
(3,3,3,'2024-01-04','2024-01-10'),
(4,4,4,'2024-01-05',NULL),
(5,5,5,'2024-01-06','2024-01-08'),
(6,1,6,'2024-01-07','2024-01-09'),
(7,2,7,'2024-01-08',NULL),
(8,3,8,'2024-01-09','2024-01-12'),
(9,4,9,'2024-01-10','2024-01-14'),
(10,5,10,'2024-01-11',NULL),
(11,6,1,'2024-02-01','2024-02-05'),
(12,7,2,'2024-02-02','2024-02-06'),
(13,8,3,'2024-02-03',NULL),
(14,9,4,'2024-02-04','2024-02-10'),
(15,10,5,'2024-02-05','2024-02-08');

-- Inserting values into payements-- 

INSERT INTO payments VALUES
(1,1,'2024-01-05',120),
(2,2,'2024-01-03',150),
(3,3,'2024-01-10',100),
(4,4,'2024-01-05',130),
(5,5,'2024-01-08',110),
(6,6,'2024-01-09',90),
(7,7,'2024-01-08',140),
(8,8,'2024-01-12',95),
(9,9,'2024-01-14',85),
(10,10,'2024-01-11',105),
(11,11,'2024-02-05',120),
(12,12,'2024-02-06',150),
(13,13,'2024-02-03',100),
(14,14,'2024-02-10',130),
(15,15,'2024-02-08',110);

-- Q1) 1.	List all movies currently rented out (not yet returned).--
SELECT movies.title
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
WHERE rentals.return_date IS NULL;

-- Q2) 2.	Find the top 5 most rented movies of all time.--
SELECT movies.title, COUNT(rentals.movie_id)
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
GROUP BY movies.title
ORDER BY COUNT(rentals.movie_id) DESC
LIMIT 5;

-- Q3) 3.	Calculate the total revenue generated from movie rentals per month.--
SELECT MONTH(payment_date), SUM(amount)
FROM payments
GROUP BY MONTH(payment_date);

-- Q4) Identify customers who have rented the most movies.--
SELECT customers.name, COUNT(rentals.rental_id)
FROM customers
JOIN rentals ON customers.customer_id = rentals.customer_id
GROUP BY customers.name
ORDER BY COUNT(rentals.rental_id) DESC;

-- Q5) Find the average rental duration for each movie.--
SELECT movies.title, AVG(DATEDIFF(return_date, rental_date))
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
WHERE return_date IS NOT NULL
GROUP BY movies.title;

-- Q6) List customers with overdue rentals (rented more than 7 days ago and not returned).--
SELECT customers.name
FROM customers
JOIN rentals ON customers.customer_id = rentals.customer_id
WHERE rentals.return_date IS NULL
AND DATEDIFF(CURDATE(), rentals.rental_date) > 7;

-- Q7) Calculate the number of rentals per genre.--
SELECT movies.genre, COUNT(rentals.rental_id)
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
GROUP BY movies.genre;

-- Q8) Find movies that have never been rented.--
SELECT title
FROM movies
WHERE movie_id NOT IN
(
    SELECT movie_id FROM rentals
);

-- Q9) Identify the most profitable movie (highest total rental revenue).--
SELECT movies.title, SUM(payments.amount)
FROM movies
JOIN rentals ON movies.movie_id = rentals.movie_id
JOIN payments ON rentals.rental_id = payments.rental_id
GROUP BY movies.title
ORDER BY SUM(payments.amount) DESC
LIMIT 1;

-- Q10) Find the busiest day of the week for rentals.--
SELECT DAYNAME(rental_date), COUNT(rental_id)
FROM rentals
GROUP BY DAYNAME(rental_date)
ORDER BY COUNT(rental_id) DESC
LIMIT 1;
