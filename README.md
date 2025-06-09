# sql_library_management_project
**Project Title**: Library Management Project 

**Database:** library_project_2

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

****Objectives** :**

Set up the Library Management System Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.

**Database Creation:** Created a database named l**ibrary_project_2**

**Table Creation:** Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.


DROP TABLE IF EXISTS branch;

CREATE TABLE branch(

	branch_id VARCHAR(10) PRIMARY KEY,
 
	manager_id VARCHAR(10),
 
	branch_address VARCHAR(55),
 
	contact_no VARCHAR(10)
 
);


ALTER TABLE branch 

MODIFY COLUMN contact_no VARCHAR(20);




DROP TABLE IF EXISTS books;
CREATE TABLE books (

	isbn VARCHAR(20) PRIMARY KEY,
  book_title VARCHAR(75),	
	category VARCHAR(10),
	rental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(35),
	publisher VARCHAR(55)

);


ALTER TABLE books
MODIFY COLUMN category VARCHAR(20);



DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(15),
	salary INT,
	branch_id VARCHAR(25) -- FK 
);

    
DROP TABLE IF EXISTS members;
CREATE TABLE members (
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(20),
	member_address VARCHAR(15),
	reg_date DATE

);


DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
	issued_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10), -- FK
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(20), -- FK
	issued_emp_id VARCHAR(10) -- FK

);


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
	return_id VARCHAR(10) PRIMARY KEY,
	issued_id VARCHAR(10), -- FK
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20) -- FK		

);


-- IDENTIFYING FOREIGN KEYS (FK)

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id) 
REFERENCES members(member_id); 


ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);


ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


SELECT * FROM return_status
