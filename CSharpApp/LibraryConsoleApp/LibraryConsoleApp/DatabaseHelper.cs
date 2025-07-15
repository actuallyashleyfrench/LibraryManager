
using System.Configuration;
using Microsoft.Data.SqlClient;

namespace LibraryConsoleApp
{
    /// <summary>
    /// Provides database operations for Library Console App.
    /// </summary>
    public static class DatabaseHelper
    {

        private static string connectionString = ConfigurationManager.ConnectionStrings["LibraryManagerDB"].ConnectionString;


        /// <summary>
        /// Displays titles of available books in library.
        /// </summary>
        public static void ViewAvailableBooks()
        {
            string query = 
                @"SELECT Title 
                FROM Books 
                WHERE IsAvailable = 1";

            ExecuteReaderQuery(query, reader =>
            {
                Console.WriteLine("\nAvailable Books in Library:\n");

                while (reader.Read())
                {
                    Console.WriteLine("- " + reader["Title"]);
                }
            });
               
        }

        /// <summary>
        /// Finds books by author based on user input
        /// </summary>
        /// <param name="firstName">The first name of the author.</param>
        /// <param name="lastName">The last name of the author.</param>
        public static void SearchBooksByAuthor(string firstName, string lastName)
        {
            string query =
                @"SELECT 
                   b.Title, 
                   b.PublishedYear
                FROM Books b JOIN Authors a ON b.AuthorId = a.AuthorID
                WHERE a.FirstName = @FirstName AND a.LastName = @LastName";

            var parameters = new SqlParameter[]
            {
                new SqlParameter("@FirstName", firstName),
                new SqlParameter("@LastName", lastName)
            };

            ExecuteReaderQuery(query, reader =>
            {
                Console.WriteLine($"\nBooks by {firstName} {lastName}:\n");

                bool hasRows = false;

                while (reader.Read())
                {
                    hasRows = true;
                    Console.WriteLine($"- {reader["Title"]} ({reader["PublishedYear"]})");
                }
                if(!hasRows)
                {
                    Console.WriteLine("No books found by this author.");
                }
            }, parameters);
        }

        /// <summary>
        /// Displays all active book loans with member names and loan dates.
        /// </summary>
        public static void ViewCurrentLoans()
        {
            string query =
                @"SELECT
                    m.FirstName + ' ' + m.LastName AS Member,
                    b.Title,
                    l.LoanDate
                FROM Members m 
                RIGHT JOIN Loans l ON m.MemberId = l.MemberId
                JOIN Books b ON l.BookId = b.BookId
                WHERE l.ReturnDate IS NULL";

            ExecuteReaderQuery(query, reader =>
            {
                Console.WriteLine("\nCurrent Loans:\n");
                while (reader.Read())
                {
                    Console.WriteLine($"- \"{reader["Title"]}\" - {reader["Member"]} - {((DateTime)reader["LoanDate"]).ToShortDateString()}");
                }
            });
        }

        /// <summary>
        /// Adds a new member to the library.
        /// </summary>
        /// <param name="firstName">The first name of the member.</param>
        /// <param name="lastName">The last name of the member.</param>
        public static void AddNewMember(string firstName, string lastName)
        {
            string query = @"
            INSERT INTO Members (FirstName, LastName, JoinDate) VALUES
            (@FirstName, @LastName, GETDATE())
            ";

            var parameters = new SqlParameter[]
            {
                new SqlParameter("@FirstName", firstName),
                new SqlParameter("@LastName", lastName)
            };

            ExecuteNonQuery(query, parameters);
            
            Console.WriteLine($"\nNew Member '{firstName} {lastName}' added!");
            
            
        }

        /// <summary>
        /// Inserts new loan from user input. Validates that book is available and user exists.
        /// </summary>
        /// <param name="bookId">Id for book to be loaned.</param>
        /// <param name="memberId">Id for the member renting the book.</param>
        public static void RecordNewLoan(int bookId, int memberId)
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // 1. Check if book is available
                    string checkBookQuery = "SELECT IsAvailable FROM Books WHERE BookId = @BookId";
                    using (SqlCommand bookCommand = new SqlCommand(checkBookQuery, connection))
                    {
                        bookCommand.Parameters.AddWithValue("@BookId", bookId);
                        object? result = bookCommand.ExecuteScalar();

                        if (result == null || !(bool)result)
                        {
                            Console.WriteLine("\nThat book is currently not available for loan.");
                            return;
                        }
                    }

                    // 2. Check if member exists
                    string checkMemberQuery = "SELECT COUNT(*) FROM Members WHERE MemberId = @MemberId";
                    using (SqlCommand memberCommand = new SqlCommand(checkMemberQuery, connection))
                    {
                        memberCommand.Parameters.AddWithValue("@MemberId", memberId);
                        int memberCount = (int)memberCommand.ExecuteScalar();

                        if (memberCount == 0)
                        {
                            Console.WriteLine("\nMember does not exist.");
                            return;
                        }
                    }

                    // 3. Insert loan
                    string insertLoanQuery = @"
                        INSERT INTO Loans (BookId, MemberId, LoanDate)
                        VALUES (@BookId, @MemberId, @LoanDate)";
                    using (SqlCommand insertLoanCommand = new SqlCommand(insertLoanQuery, connection))
                    {
                        insertLoanCommand.Parameters.AddWithValue("@BookId", bookId);
                        insertLoanCommand.Parameters.AddWithValue("@MemberId", memberId);
                        insertLoanCommand.Parameters.AddWithValue("@LoanDate", DateTime.Today);
                        insertLoanCommand.ExecuteNonQuery();
                    }

                    Console.WriteLine($"\nLoan successfully recorded for BookID: {bookId}, Member ID: {memberId} on {DateTime.Today:d}");

                    // 4. Mark book as unavailable
                    string updateBookQuery = "UPDATE Books SET IsAvailable = 0 WHERE BookId = @BookId";
                    using (SqlCommand updateBookCommand = new SqlCommand(updateBookQuery, connection))
                    {
                        updateBookCommand.Parameters.AddWithValue("@BookId", bookId);
                        updateBookCommand.ExecuteNonQuery();
                    }

                    Console.WriteLine($"\nBook: {bookId} marked as unavailable.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error during loan processing: {ex.Message}");
                }
            }





            

        }

        /// <summary>
        /// Executes a SELECT query and handles the resulting SqlDataReader.
        /// </summary>
        /// <param name="query">The SQL SELECT query to execute.</param>
        /// <param name="handleReader">Action to process the SqlDataReader result.</param>
        /// <param name="parameters">Optional SQL parameters for the query.</param>
        private static void ExecuteReaderQuery(string query, Action<SqlDataReader> handleReader, SqlParameter[]? parameters = null)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }
                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        handleReader(reader);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }
            }
        }

        /// <summary>
        /// Executes a non-query SQL command (INSERT, UPDATE, DELETE).
        /// </summary>
        /// <param name="query">The SQL command to execute.</param>
        /// <param name="parameters">Optional SQL parameters for the command.</param>
        private static void ExecuteNonQuery(string query, SqlParameter[]? parameters = null)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }

            }
        }
    }
}
