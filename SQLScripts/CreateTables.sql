-- Create the database
CREATE DATABASE LibraryManagerDB;
GO

-- Select the database
USE LibraryManagerDB;
GO

-- Create Authors table
CREATE TABLE Authors (
	AuthorId INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	BirthYear INT
);
GO

-- Create Books table
CREATE TABLE Books (
	BookId INT PRIMARY KEY IDENTITY(1,1),
	Title VARCHAR(100) NOT NULL,
	Genre VARCHAR(50),
	PublishedYear INT,
	IsAvailable BIT DEFAULT 1,
	AuthorId INT FOREIGN KEY REFERENCES Authors(AuthorId)
);
GO

-- Create Members table
CREATE TABLE Members (
	MemberId INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	JoinDate DATE
);
GO

-- Create Loans table
CREATE TABLE Loans (
	LoanId INT PRIMARY KEY IDENTITY(1,1),
	BookId INT FOREIGN KEY REFERENCES Books(BookId),
	MemberId INT FOREIGN KEY REFERENCES Members(MemberId),
	LoanDate DATE NOT NULL,
	ReturnDate DATE NULL
);
GO