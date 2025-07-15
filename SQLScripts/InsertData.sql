-- Insert sample authors
INSERT INTO Authors (FirstName, LastName, BirthYear) VALUES 
('J.K.', 'Rowling', 1965),
('Stephen', 'King', 1947),
('George', 'Orwell', 1903),
('Jane', 'Austen', 1775),
('Agatha', 'Christie', 1890);

-- Insert 10 books (2 per author)
INSERT INTO Books (Title, Genre, PublishedYear, IsAvailable, AuthorId) VALUES
-- J.K. Rowling
('Harry Potter and the Sorcerer''s Stone', 'Fantasy', 1997, 1, 1),
('Harry Potter and the Chamber of Secrets', 'Fantasy', 1998, 1, 1),

-- Stephen King
('The Shining', 'Horror', 1977, 1, 2),
('It', 'Horror', 1986, 0, 2),

-- George Orwell
('1984', 'Dystopian', 1949, 1, 3),
('Animal Farm', 'Political Satire', 1945, 0, 3),

-- Jane Austen
('Pride and Prejudice', 'Romance', 1813, 1, 4),
('Sense and Sensibility', 'Romance', 1811, 1, 4),

-- Agatha Christie
('Murder on the Orient Express', 'Mystery', 1934, 1, 5),
('And Then There Were None', 'Mystery', 1939, 0, 5);

-- Insert 5 library members
INSERT INTO Members (FirstName, LastName, JoinDate) VALUES
('Emily', 'Johnson', '2022-01-15'),
('Michael', 'Williams', '2023-03-08'),
('Sophia', 'Davis', '2021-06-21'),
('Daniel', 'Martinez', '2024-02-10'),
('Olivia', 'Brown', '2022-11-05');

-- Insert 7 loan records
INSERT INTO Loans (BookId, MemberId, LoanDate, ReturnDate) VALUES
-- Emily Johnson borrowed "It" (still out)
(4, 1, '2024-06-20', NULL),

-- Michael Williams borrowed "Animal Farm" (returned)
(6, 2, '2024-05-10', '2024-05-24'),

-- Sophia Davis borrowed "And Then There Were None" (still out)
(10, 3, '2024-07-01', NULL),

-- Daniel Martinez borrowed "1984" (returned)
(5, 4, '2024-03-02', '2024-03-20'),

-- Olivia Brown borrowed "Harry Potter and the Sorcerer''s Stone" (still out)
(1, 5, '2024-06-28', NULL),

-- Emily Johnson borrowed "The Shining" (returned)
(3, 1, '2024-01-15', '2024-02-01'),

-- Michael Williams borrowed "Murder on the Orient Express" (still out)
(9, 2, '2024-07-05', NULL);