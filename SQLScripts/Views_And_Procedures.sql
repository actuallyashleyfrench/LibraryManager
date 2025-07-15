/* 
 * Create a view ActiveLoansView showing:
 * BookTitle, MemberName, LoanDate (where ReturnDate is null)
 */

CREATE VIEW ActiveLoansView AS
SELECT 
	b.Title,
	m.FirstName + ' ' + m.LastName AS MemberName,
	l.LoanDate
FROM Books b JOIN Loans l ON b.BookId = l.BookId
JOIN Members m ON l.MemberId = m.MemberId
WHERE l.ReturnDate IS NULL;
GO

SELECT * FROM ActiveLoansView;
GO

/*
 * Create a stored procedure:
 * EXEC GetBooksByAuthor 'Stephen King'
 * Returns all books by that author.
 */
 CREATE PROCEDURE GetBooksByAuthor
	@AuthorName NVARCHAR(100)
AS
BEGIN
	SELECT 
		b.Title
	FROM Books b JOIN Authors a ON b.AuthorId = a.AuthorId
	WHERE a.FirstName + ' ' + a.LastName = @AuthorName;
END;

EXEC GetBooksByAuthor 'Stephen King';
