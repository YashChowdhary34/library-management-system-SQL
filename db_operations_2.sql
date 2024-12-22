SELECT * FROM branch;
SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status AS ist
LEFT JOIN
return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.issued_id IS NULL;

-- Task 13: Identify Members with Overdue Books return period - within 30days
-- join issued_status - members - return_status - books
-- filter return_status IS NULL && issued_date > 30 days
SELECT 
	m.member_id,
	m.member_name,
	ist.issued_date,
	CURRENT_DATE - ist.issued_date AS days_overdue
FROM issued_status AS ist
JOIN
members AS m
ON ist.issued_member_id = m.member_id
JOIN 
books AS b
ON ist.issued_book_isbn = b.isbn
LEFT JOIN
return_status AS rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
	AND 
	(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

-- Task 14: Update Book Status on Return Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
CREATE OR REPLACE PROCEDURE add_return_record(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$
DECLARE
	v_isbn VARCHAR(25);
	v_book_name VARCHAR(55);
BEGIN
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES 
	(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	SELECT
		issued_book_isb,
		issued_book_name
		INTO
		v_isbn,
		v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;
	
	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE 'Thank you for returning the book %', v_book_name;
END;
$$

CALL add_return_record();

-- Task 15: Branch Performance Report
/*Create a query that generates a performance report for each branch, showing the number of
books issued, the number of books returned, and the total revenue generated from book rentals.*/
-- issued_status - return_status - books

DROP TABLE IF EXISTS performance_report;
CREATE TABLE performance_report AS
SELECT 
	br.branch_id,
	br.manager_id,
	SUM(b.rental_price) AS revenue,
	COUNT(ist.issued_id) AS books_issued,
	COUNT(rst.return_id) AS books_returned
FROM issued_status AS ist
JOIN
employees AS e
ON ist.issued_emp_id = e.emp_id
JOIN
branch AS bR
ON e.branch_id = br.branch_id
LEFT JOIN
return_status AS rst
ON rst.issued_id = ist.issued_id
JOIN
books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT * FROM performance_report;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
who have issued at least one book in the last 2 months. */

DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members AS 
SELECT DISTINCT 
	members.member_id AS active_members_id,
	members.member_name AS active_members_name,
	ist.issued_date AS issued_date
FROM members
JOIN
issued_status AS ist
ON members.member_id = ist.issued_member_id
WHERE ist.issued_date >= CURRENT_DATE - INTERVAL '2 month';

SELECT * FROM active_members;
-- alternative way is to use sub query

SELECT * FROM members
WHERE member_id IN (SELECT 
						DISTINCT issued_member_id
					FROM issued_status
					WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month')

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch. */

SELECT 
	ist.issued_emp_id AS emp_id,
	emp.branch_id,
	COUNT(ist.issued_id) AS number_of_books_processed
FROM issued_status AS ist
JOIN
employees AS emp
ON ist.issued_emp_id = emp.emp_id
GROUP BY 1, 2;

/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" 
in the books table. Display the member name, book title, and the number of times they've issued 
damaged books. */

SELECT * FROM branch;
SELECT * FROM books;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

SELECT 
	*
	
FROM members AS mem
JOIN
issued_status AS ist
ON mem.member_id = ist.issued_member_id
JOIN
return_status AS rst
ON ist.issued_id = rst.issued_id
WHERE rst.book_quality = 'Damaged'
	AND
	COUNT()