-- Get a list of all books and their authors.
SELECT 
	b.Title,
	a.FirstName + ' ' + a.LastName AS Author
FROM Books b LEFT JOIN Authors a ON b.AuthorId = a.AuthorId;

-- List all members who currently have books checked out.
SELECT 
	m.FirstName + ' ' + m.LastName AS Member
FROM Members m JOIN Loans l ON m.MemberId = l.MemberId
WHERE l.ReturnDate IS NULL;


-- Show all books that are not available (IsAvailable = 0).
SELECT *
FROM Books 
WHERE IsAvailable = 0;


-- Find all books by a specific author (e.g., "Stephen King").
SELECT 
	b.Title,
	a.FirstName + ' ' + a.LastName AS Author
FROM Books b JOIN Authors a ON b.AuthorId = a.AuthorId
WHERE a.FirstName + ' ' + a.LastName = 'Stephen King';

-- Insert a recent loan (within last 30 days)
INSERT INTO Loans  (BookId, MemberId, LoanDate, ReturnDate)
VALUES (2, 3, GETDATE() - 7, NULL);

-- Update availability for book in new loan
UPDATE Books
SET IsAvailable = 0
WHERE BookId = 2;

-- Show all books loaned out in the past 30 days.
SELECT 
	b.Title,
	l.LoanDate,
	l.ReturnDate
FROM Books b JOIN Loans l ON b.BookId = l.BookId
WHERE l.LoanDate >= DATEADD(DAY, -30, GETDATE());


-- List the top 3 most borrowed books (by count).
SELECT TOP 3
	b.title,
	COUNT(l.loanId) AS 'Times Borrowed'
FROM Books b JOIN Loans l ON b.BookId = l.BookId
GROUP BY b.Title
ORDER BY [Times Borrowed] DESC;

-- Find the average loan duration (in days).
SELECT 
	AVG(DATEDIFF(DAY,LoanDate, 
	CASE 
		WHEN ReturnDate IS NULL THEN GETDATE()
		ELSE ReturnDate
		END)) AS 'Average Loan Duration'
FROM Loans;

-- Get all books published between 1990 and 2010.
SELECT Title, PublishedYear
FROM Books
WHERE PublishedYear BETWEEN 1990 AND 2010;

-- List members who have borrowed more than 1 book.
SELECT
	m.FirstName + ' ' + m.LastName AS Member,
	COUNT(l.MemberId) AS 'Books Borrowed'
FROM Members m JOIN Loans l ON m.MemberId = l.MemberId
GROUP BY m.FirstName, m.LastName
HAVING COUNT(l.LoanId) > 1;


-- Show full loan history (Member name, Book title, LoanDate, ReturnDate).
SELECT 
	m.FirstName + ' ' + m.LastName AS Member,
	b.Title,
	l.LoanDate,
	l.ReturnDate
FROM Loans l 
JOIN Members m ON l.MemberId = m.MemberId
JOIN Books b ON l.BookId = b.BookId;


-- Find authors who have books but none of their books have ever been loaned.
SELECT 
	a.FirstName + ' ' + a.LastName AS Author
FROM Authors a
JOIN Books b ON a.AuthorId = b.AuthorId
LEFT JOIN Loans l ON l.BookId = b.BookId
WHERE l.LoanId IS NULL
GROUP BY a.FirstName, a.LastName;

-- Insert new member with no loans
INSERT INTO Members (FirstName, LastName, JoinDate)
VALUES ('Ashley', 'French', GETDATE());

-- Count how many books each member has ever borrowed.
SELECT
	m.FirstName + ' ' + m.LastName AS Member,
	COUNT(l.MemberId) AS 'Books Borrowed'
FROM Members m 
LEFT JOIN Loans l ON m.MemberId = l.MemberId
GROUP BY m.FirstName, m.LastName;



-- Show each author’s number of books and average book age.
SELECT
	a.FirstName + ' ' + a.LastName AS Author,
	AVG(YEAR(GETDATE()) - b.PublishedYear) AS 'Avg Book Age',
	COUNT(b.BookId) AS 'Number of Books'
FROM Authors a JOIN Books b ON a.AuthorId = b.AuthorId
GROUP BY a.FirstName, a.LastName;

-- Mark a returned book as available and update its ReturnDate.
UPDATE Books
SET IsAvailable = 1
WHERE BookId = 10;

UPDATE Loans
SET ReturnDate = GETDATE()
WHERE LoanId = 3;


-- Increase the published year of all books from before 1980 by 1 (simulate correction).
UPDATE Books
SET PublishedYear = PublishedYear + 1
WHERE PublishedYear < 1980;


-- Delete members who haven’t borrowed any books.
DELETE Members
FROM Members m LEFT JOIN Loans l ON m.MemberId = l.MemberId
WHERE l.LoanId IS NULL;


-- Remove loans that were returned over 30 days ago.
DELETE Loans
WHERE ReturnDate < DATEADD(DAY, -30, GETDATE())
	AND ReturnDate IS NOT NULL;

-- Show books where the title contains “Secret”.
SELECT
	Title
FROM Books
WHERE Title LIKE '%Secret%';

INSERT INTO Loans (BookId, MemberId, LoanDate, ReturnDate) VALUES 
(5, 5, '2024-01-10', '2024-01-20'), 
(5, 5, '2024-06-01', NULL);        

-- Find members who borrowed the same book more than once.
SELECT 
	m.FirstName + ' ' + m.LastName AS Member,
	b.Title,
	COUNT(*) AS 'Times Borrowed'
FROM Members m JOIN Loans l on m.MemberId = l.MemberId
JOIN Books b ON l.BookId = b.BookId
GROUP BY m.FirstName, m.LastName, b.Title
HAVING COUNT(*) > 1;

-- Get the latest loan for each member.
SELECT TOP 1
	m.FirstName + ' ' + m.LastName AS Member,
	l.LoanDate
FROM Members m JOIN Loans l ON m.MemberId = l.MemberId
GROUP BY m.FirstName, m.LastName
ORDER BY l.LoanDate DESC;

-- Find books that have never been borrowed.
SELECT
	b.Title
FROM Books b LEFT JOIN Loans l ON b.BookId = l.BookId
WHERE l.LoanId IS NULL;

