-- PROJECT TASK

-- TASK 1. create a new book record == "978-1-60129-456-2", 'To kill a mockingbird', 'classic', 6.00, 'yes', 'Harper lee', 'J.B lippincout'

	INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
	VALUES('978-1-60129-456-2', 'To kill a mockingbird', 'classic', 6.00, 'yes', 'Harper lee', 'J.B lippincout');
	SELECT * FROM books;

-- Task 1b Create a new members record == ('C120','Ken', '145 Main st', '2025-06-01'),
-- ('C121','Focus', '133 Main st', '2025-05-01')

	INSERT INTO members(member_id, member_name, member_address, reg_date)
	VALUES
	('C120','Ken', '145 Main st', '2025-06-01'),
	('C121','Focus', '133 Main st', '2025-05-01');

-- Task 2. Update an existing member's Address
	UPDATE members
	SET member_address = '125 Main st'
	WHERE member_id = 'C101';
	SELECT * 
	FROM members;

-- Task 2b Update an existing member's Name and Address.
	UPDATE members
	SET member_name = 'Kachi Focus', member_address = '200 Main st'
	WHERE member_id = 'C102' ;
	SELECT *
	FROM members ;

-- Task 3. Delete a Record from the Issued status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
	DELETE FROM issued_status
	WHERE issued_id = 'IS121';
	SELECT *
	FROM issued_status ;

-- Task 4. Retrieve all Books issued by a specific employee -- Objective: Retrieve all books issued by the employee with emp_id = 'E101'. 

	SELECT *
	FROM issued_status 
	WHERE issued_emp_id = 'E101';

-- Task 5. List Members who have issued More than one Book -- Objectives Use GROUP BY to find members who have issued more than one book. 
	SELECT 
	issued_emp_id
	-- COUNT(issued_id) as total_book_issued
	FROM issued_status 
	GROUP BY issued_emp_id
	HAVING COUNT(issued_id) >1;

-- Task 6. Create summary Tables: Use CTAS to generate new tables based on the querry results -- each book and total_books-issued_count. 
-- POV : we want to know the number of  each book  issued.( in this case we are going to be joining two tables together"the books table and issued_status table"
	 SELECT *
	 FROM books as b
	 JOIN
	 issued_status as ist
	 ON ist.issued_book_isbn = b.isbn;
	 
 -- Task 6b. The total amount of each book issued. 
 
	 SELECT 
	  b.isbn,
	  b.book_title,
	 COUNT(ist.issued_id) as no_issued
	 FROM books as b
	 JOIN
	 issued_status as ist
	 ON ist.issued_book_isbn = b.isbn
	  GROUP BY 1, 2;
  
  -- Task 6c. create a summary Table  use CTAS
 
	 CREATE TABLE book_count
	 AS
		 SELECT
		 b.isbn,
		 b.book_title,
		 COUNT(ist.issued_id) as no_issued
		 FROM books as b
		 JOIN
		 issued_status as ist
		 ON ist.issued_book_isbn = b.isbn
		 GROUP BY 1,2;

	SELECT * FROM book_count;

-- Task 7. Retrieve all books in a specific category. 
		SELECT * FROM books
		WHERE category = 'Children';

-- Task 8. Find Total Rental income by each category. 
		SELECT 
		category,
		SUM(rental_price) as Total_rental_income
		FROM books
		GROUP BY 1;

-- OR(method 2 to avoid multiple entries, use JOIN statement)
		SELECT 
		category,
		SUM(rental_price) as Total_rental_income
		FROM books as b
		JOIN
		issued_status as ist
		ON ist.issued_book_isbn = b.isbn
		GROUP BY 1;

-- Task 9. List members who registered in the last 180 days :
		SELECT *
		FROM members
		WHERE reg_date >= CURRENT_DATE() - INTERVAL 180 DAY;
    
    -- Task 10. List Employees with their Branch Manager's Name and their branch details.
		SELECT 
			el.*,
			b.manager_id,
		   e2.emp_name AS Manager,
			b.branch_address AS Branch_details
			FROM employees AS el
			JOIN
			branch AS b
			ON b.branch_id = el.branch_id
			JOIN
			employees AS e2
			ON b.manager_id = e2.emp_id;
        
	-- Task 11. Create a table of Books with Rental Price Above a certain Threshold of '7USD'
		CREATE TABLE books_price_above_7USD
		AS
			SELECT * FROM books
			WHERE rental_price > 7;
			
			SELECT * FROM books_price_above_7usd;
			
		
	-- TAsk 12. Retrieve the List of books not been returned. 
		SELECT 
			DISTINCT ist.issued_book_name
			FROM issued_status As ist
			LEFT JOIN
			return_status AS rs
			ON ist.issued_id = rs.issued_id
			WHERE rs.return_id IS NULL;
        
/*Task 13. Identify Members with Overdue Books
Write a Querry to identify members who have overdue books (assume a 30-day return period). Display the member's_id, members's_name, book_title, issue_date, and days overdue.*/
    
    -- Steps to follow: 
    -- join the following tables : issued_status, members, books return_status
    -- filter books which are return
    -- Overdue > 30days
    
		SELECT 
			ist.issued_member_id,
			m.member_name,
			bk.book_title,
			ist.issued_date,
			-- rs.return_date,
			CURRENT_DATE-ist.issued_date AS Overdue_days
		FROM issued_status AS ist
		JOIN
		members AS m
			  ON m.member_id = ist.issued_member_id
		JOIN
		books AS bk
		ON bk.isbn = ist.issued_book_isbn
		 LEFT JOIN
		return_status AS rs
		ON rs.issued_id = ist.issued_id
		WHERE rs.return_date IS NULL
			 AND
		(CURRENT_DATE - ist.issued_date) > 30
		ORDER BY 1;

/* Task 14: Update Book status on Return
Write a querry to update the status of books in the books table to "Yes" when they are returned(based on entries in the return_status table). */

-- Testing functions
		SELECT * FROM issued_status;
		SELECT * FROM books
		WHERE isbn = '978-0-307-58837-1';
		
		SELECT * FROM issued_status
		WHERE issued_book_isbn = '978-0-307-58837-1'

		SELECT * FROM return_status
		WHERE issued_id = 'IS135'

-- Use STORED PROCEDURES
	DELIMITER $$
	CREATE PROCEDURE add_return_records(
	IN p_return_id VARCHAR(10), 
	IN p_issued_id VARCHAR(10),
	IN p_book_quality VARCHAR(15)
	)
	BEGIN
	-- All your logic and codes here

	DECLARE v_isbn VARCHAR(50);
	DECLARE v_book_name VARCHAR(80);

	-- Insert into return_status table.
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES
	(p.return_id, p_issued_id, CURRENT_DATE, p.book_quality);

	SELECT
	  issued_book_isbn,
	  issued_book_name
	  INTO
	  v_isbn,
	  v_book_name
	  FROM issued_status
	  WHERE issued_id = p_issued_id;
	  
	  UPDATE books
	  SET status = 'yes'
	  WHERE isbn = v_isbn;
	  
	  SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
	  END $$
	  DELIMITER ;

	CALL add_return_records('RS138', 'IS135', 'Good');

/* Task 15. Branch performance Report
Create a querry that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from rentals. */

	CREATE TABLE branch_reports
	AS
	SELECT 
	   b.branch_id,
	   b.manager_id,
	   COUNT(ist.issued_id) AS number_book_issued,
	   COUNT(rs.return_id) AS number_of_book_return,
	   SUM(bk.rental_price) as total_revenue
	FROM issued_status AS ist
	JOIN
	employees AS e
	ON e.emp_id = ist.issued_emp_id
	JOIN
	branch AS b
	ON e.branch_id = b.branch_id
	LEFT JOIN
	return_status AS rs
	ON rs.issued_id = ist.issued_id
	JOIN
	books AS bk
	ON ist.issued_book_isbn = bk.isbn
	GROUP BY 1,2;

	SELECT * FROM branch_reports;

-- Task 16. CTAS: Create a table of Active Members
-- Use the CREATE TABLE As (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 15 months.
	CREATE TABLE active_members
	AS
	SELECT * FROM members
	WHERE member_id IN (
		  SELECT 
	  DISTINCT issued_member_id
	FROM issued_status
	WHERE
	  issued_date >= CURRENT_DATE () - INTERVAL 15 month
	  );
	  
	  SELECT * FROM active_members;
  
  
  
  -- Task 17. Find Employees with the Most Book issues processed
  -- Write a querry to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed and their branch. 
  
	  SELECT 
		e.emp_name,
		b.*,
		COUNT(ist.issued_id )AS no_book_issued
	  FROM issued_status AS ist
	  JOIN
	  employees AS e
	  ON e.emp_id = ist.issued_emp_id
	  JOIN
	  branch AS b
	  ON e.branch_id = b.branch_id
	  GROUP BY 1,2
  
  /*Task 18. Stored Procedure Objectives: 
  create a stored procedure to manage the status of books in a library system.
  Description : Write a stored procedure that updates the status of a book in the library based on its issuance. 
  the procedure should function as follows: 
  
  The stored procedure should take the book_id as an input parameter.
  The procedure should first check if the book is avialble (status = 'yes'). if the book is available, it should be issued, \
  and the status in the books table should be updated to 'no' if the book is not avialble (status = 'no'), 
  the procedure should return an error message indicating that the book is currently not avialable. */
  
  -- SOLUTION
	  DELIMITER $$
	  CREATE PROCEDURE issue_book(
	  p_issued_id VARCHAR(10), 
	  p_issued_member_id VARCHAR(30),
	  p_issued_book_isbn VARCHAR(50),
	  p_issued_emp_id VARCHAR(10)
	  ) 
	 
	  BEGIN
	   -- All Varaibles
		DECLARE v_status VARCHAR(10);
	  -- All Codes
	  -- checking if book is available 'yes'
	  SELECT status INTO v_status
	  FROM books
	  WHERE isbn = p_issued_book_isbn;
	  IF v_status = 'yes' THEN
		INSERT INTO   issued_status(issued_id,issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES(p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id); 
		SELECT CONCAT('Book records added successfully for book isbn : ', p_issued_book_isbn) AS message;
			
			UPDATE books
			SET status = 'no'
			WHERE isbn = p_issued_book_isbn;
	  
	   ELSE
		SELECT CONCAT('Sorry to inform you the book you have requested is unavailable book_isbn: ', p_issued_book_isbn) AS message;
	  END IF;
	  END $$
	  
	  DELIMITER ;
	  CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
	  
	  CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');