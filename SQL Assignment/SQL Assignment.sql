use classicmodels;

## ASSIGNMENT DAY 3 ##

# Q1 #

select customerNumber,customerName, state, creditLimit from customers 
where state is not null and creditLimit between 50000 and 100000 order by creditLimit desc;

# Q2 #

select distinct productline from products where productline like "%cars%";

##ASSIGNMENT DAY 4 ##

# Q1 #

SELECT orderNumber,status, CASE WHEN comments IS NULL THEN '-' ELSE comments END AS comments
FROM orders
WHERE status = 'Shipped';

SELECT orderNumber,status, COALESCE(comments, '-') as comments
FROM orders
WHERE status = 'Shipped';

# Q2 #

SELECT employeeNumber, firstName, jobTitle,
CASE
	WHEN jobTitle = 'President' THEN 'P'
	WHEN jobTitle LIKE 'Sales Manager%' OR jobTitle LIKE 'Sale Manager%' THEN 'SM'
	WHEN jobTitle = 'Sales Rep' THEN 'SR'
	WHEN jobTitle LIKE '%VP%' THEN 'VP'
END AS job_title_abbr
FROM employees;

## ASSIGNMENT DAY 5 ## 

# Q1 #

SELECT * FROM payments;
SELECT YEAR(paymentDate) AS pay_year, MIN(amount) AS min_amount
FROM payments
GROUP BY YEAR(paymentDate)
ORDER BY pay_year;

# Q2 #

SELECT * FROM orders;
SELECT YEAR(orderDate) AS order_year,
CASE
	WHEN QUARTER(orderDate) = 1 THEN 'Q1'
	WHEN QUARTER(orderDate) = 2 THEN 'Q2'
	WHEN QUARTER(orderDate) = 3 THEN 'Q3'
	WHEN QUARTER(orderDate) = 4 THEN 'Q4'
END AS order_quarter,
COUNT(DISTINCT customerNumber) AS unique_customers,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_year, order_quarter
ORDER BY order_year, order_quarter;

# Q3 #

SELECT * FROM payments;
SELECT DATE_FORMAT(paymentDate, '%m') Month, SUM(amount) AS TotalAmount
FROM payments
GROUP BY Month
HAVING TotalAmount BETWEEN 500000 AND 1000000
ORDER BY TotalAmount DESC;

## ASSIGNMENT DAY 6 ## 

# Q1 # 

CREATE TABLE journey (
	Bus_Id INT NOT NULL,
	Bus_Name VARCHAR(255) NOT NULL,
	Source_Station VARCHAR(255) NOT NULL,
	Destination VARCHAR(255) NOT NULL,
	Email VARCHAR(255) UNIQUE
);

# Q2 #

CREATE TABLE vendor (
	Vendor_Id INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL UNIQUE,
	Country VARCHAR(255) DEFAULT "N/A"
);

# Q3 #

CREATE TABLE movies (
    Movie_ID INT NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL,
    Release_Year VARCHAR(4) DEFAULT '-',
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows > 0)
);

# Q4 #

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255),
    location VARCHAR(255)
);

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);


## ASSIGNMENT DAY 7 ##

# Q1 #

SELECT 
	e.employeeNumber, 
	CONCAT(e.firstName, ' ', e.lastName) AS Sales_Person,
	COUNT(DISTINCT c.customerNumber) AS unique_customers
FROM Employees AS e
LEFT JOIN Customers AS c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, Sales_Person
ORDER BY unique_customers DESC;

# Q2 #

SELECT 
    c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS OrderedQuantity,
    p.quantityInStock AS TotalInventry,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS LeftQuantity
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
JOIN Orderdetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode
GROUP BY c.customerNumber, p.productCode
ORDER BY c.customerNumber;

# Q3 #

CREATE TABLE Laptop (
Laptop_Name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Colours (
Colour_Name VARCHAR(20) PRIMARY KEY
);

INSERT INTO Laptop (Laptop_Name) VALUES ('HP'), ('DELL');

INSERT INTO Colours (Colour_Name) VALUES ('WHITE'), ('SILVER'), ('Black');
    
-- Find the number of rows
SELECT COUNT(*) AS No_laptp 
FROM Laptop
CROSS JOIN Colours;

-- Shows all columns
SELECT * FROM Laptop
CROSS JOIN Colours
ORDER BY Laptop_Name;

# Q4 #

CREATE TABLE Project (
EmployeeID INT PRIMARY KEY,
FullName VARCHAR(50),
Gender VARCHAR(10),
ManagerID INT
);

INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID) VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

SELECT * FROM Project;
-- Find out the names of employees and their related managers
SELECT 
	m.FullName AS ManagerName,
    e.FullName AS EmployeeName
FROM Project e
LEFT JOIN Project m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IS NOT NULL
ORDER BY ManagerName;

## ASSIGNMENT DAY 8 ## 

# Q1 #

CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50)
);
# Q1 i #
ALTER TABLE facility
ADD PRIMARY KEY (Facility_ID);

ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT;

# Q1 ii #
ALTER TABLE facility
ADD City VARCHAR(50) NOT NULL AFTER Name;

DESCRIBE facility;

## ASSIGNMENT DAY 9 ## 

# Q1 #

CREATE TABLE university (
ID INT,
Name VARCHAR(255)
);

INSERT INTO University VALUES (1, "       Pune          University     "), 
(2, "  Mumbai          University     "),
(3, "     Delhi   University     "),
(4, "Madras University"),
(5, "Nagpur University");

SELECT * FROM university;

UPDATE University 
set name = REGEXP_REPLACE(Name, '[[:space:]]+', ' ');

SET SQL_SAFE_UPDATES=0;
SELECT * FROM university;

## ASSIGNMENT DAY 10 ## 

# Q1 # 

create view products_status as 
 select year(o.orderdate) as Year, 
 concat(count(od.productcode)," ","(",round((count(od.productcode)*100.0/sum(count(od.productcode)) over ()),0),'%',")")as value 
 from orders o  join orderdetails od on o.ordernumber=od.ordernumber
 group by year(o.orderdate)
 order by count(od.productcode) desc;
 
 select * from products_status;

## ASSIGNMENT DAY 11 ##

# Q1 #

DELIMITER //
CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT CustomerLevel VARCHAR(20))
BEGIN
    DECLARE creditLimit DECIMAL(10, 2);
    
    -- Get the credit limit for the specified customer number
    SELECT creditLimit INTO CreditLimit FROM Customers WHERE customerNumber = CustomerNumber;
    
    -- Determine the customer level based on credit limit
    CASE
        WHEN creditLimit > 100000 THEN
            SET CustomerLevel = 'Platinum';
        WHEN creditLimit BETWEEN 25000 AND 100000 THEN
            SET CustomerLevel = 'Gold';
        WHEN creditLimit < 25000 THEN
            SET CustomerLevel = 'Silver';
        ELSE
            SET CustomerLevel = 'Unknown';
    END CASE;
END //
DELIMITER ;
call getcustomerlevel (103); ## Ex ------> Silver

call getcustomerlevel (124); ## Ex ------> Platinum

call getcustomerlevel (112);

# Q2 #

select * from customers;
select * from payments;
desc payments;
call get_country_payments(2003, 'france');

## ASSIGNMENT DAY 12 ##

# Q1 # 

select year(orderdate) as year, monthname(orderdate) as month,
count(orderNumber) as total_orders,
CONCAT(IFNULL(round((COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY YEAR(orderdate), MONTHname(orderdate))) / LAG(COUNT(*), 1) 
OVER (ORDER BY YEAR(orderdate), MONTHname(orderdate)) * 100), 100)," ",'%') AS YoY_percentage_change
FROM orders group by year, month;

# Q2 #

create table emp_udf(
Emp_id int primary key auto_increment,
Name Varchar(20),
DOB date
);

Insert into emp_udf(Name,DOB) values("Piyush", "1990-03-30"), ("Aman", "1992-08-15"),
 ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

DELIMITER //
CREATE FUNCTION calculate_age(DOB DATE)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE `Years` INT;
    DECLARE `Months` INT;
    DECLARE `Age` VARCHAR(100);
    SET `Years` = TIMESTAMPDIFF(YEAR,DOB,NOW());
    SET `Months` = MOD(TIMESTAMPDIFF(MONTH,DOB,NOW()),12);
    SET `Age` = CONCAT(`Years`,' years ',`Months`,' months');
	RETURN `Age`;
END //
DELIMITER ;

SELECT
	*,
    calculate_age(DOB) AS Age
FROM emp_udf;

## Assignment Day 13 ##

# Q1 #

select
customerNumber,
customername
from customers c
where customerNumber not in (select
						customerNumber
                        from orders);
			
            
# Q2 #

select
c.customerNumber,
c.customerName,
count(o.orderNumber)  Count_orders
from customers c
left join orders o on c.customerNumber=o.customerNumber
group by c.customerNumber,c.customerName
union
select
c.customerNumber,
c.customerName,
count(o.orderNumber)  Count_orders
from customers c
right join orders o on c.customerNumber=o.customerNumber
group by c.customerNumber,c.customerName;

# Q3 #

select * from orderdetails;
select count(*) from orderdetails;
select o.ordernumber, o.quantityordered from (
select ordernumber, quantityordered, dense_rank() over (partition by ordernumber order by quantityordered desc) as abc
from orderdetails) as o where abc = 2;

# Q4 #

SELECT 
	MAX(Total),
    MIN(Total)
FROM
	(SELECT 
		orderNumber,
		COUNT(productCode) AS Total
	FROM orderdetails
	GROUP BY orderNumber) AS T1;

# Q5 # 

select * from products;

SELECT
	productLine,
    COUNT(productLine) AS Total
FROM products
WHERE buyPrice>(SELECT AVG(buyPrice) FROM products)
GROUP BY productLine
ORDER BY Total DESC;


## Assignment Day 14 ##

# Q1 #

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

DELIMITER //
CREATE PROCEDURE Emp_EH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error occurred';
    END;
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress) VALUES (p_EmpID, p_EmpName, p_EmailAddress);
END;
//
DELIMITER ;

CALL Emp_EH(1,'ABC','ABC@XYZ.com');
SELECT * FROM Emp_EH;
CALL Emp_EH(NULL,'ABC','ABC@XYZ.com');


## Assignment Day 15 ##

CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);

DELIMITER //
CREATE TRIGGER Before_Insert
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END;
//
DELIMITER ;

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', -12),
('Antonio', 'Business', '2020-10-04', 11);

SELECT * FROM Emp_BIT;


