/*=================================================================================
 *                               Connect to the LibraryManagerDB                                 
 *                                      Ashley French
 * 
 * Description:
 * A simple C# console application that connects to a SQL Server database 
 * to manage a library system. It allows viewing available books, searching 
 * books by author, viewing current loans, adding new members, and recording loans.
 * 
 * Technologies Used:
 * - C# .NET
 * - ADO.NET (SqlConnection, SqlCommand, SqlDataReader)
 * - SQL Server
 * - Try-catch for error handling
 * 
 * 
 *=================================================================================== 
 */
using System;


namespace LibraryConsoleApp
{
    class Program
    {
        static void Main()
        {
            while (true)
            {
                Console.Clear(); 

                // Display menu
                Console.WriteLine(" \nLibrary Manager\n");
                Console.WriteLine("1. View all available books");
                Console.WriteLine("2. Search books by author");
                Console.WriteLine("3. View current loans");
                Console.WriteLine("4. Add new member");
                Console.WriteLine("5. Record new loan");
                Console.WriteLine("0. Exit");
                Console.Write("\n Enter menu choice: ");

                string input = Console.ReadLine();

                switch (input)
                {
                    
                    case "1": // View all available books
                        DatabaseHelper.ViewAvailableBooks();
                        break;
                    case "2": // Search books by author
                        Console.Write("Enter author first name: ");
                        string authorFirstName = Console.ReadLine();
                        Console.Write("Enter author last name: ");
                        string authorLastName = Console.ReadLine();
                        DatabaseHelper.SearchBooksByAuthor(authorFirstName, authorLastName);
                        break;
                    case "3": // View current loans
                        DatabaseHelper.ViewCurrentLoans();
                        break;
                    case "4": // Add new member
                        Console.WriteLine("\n--Add New Member--\n");
                        Console.Write("Enter first name: ");
                        string memberFirstName = Console.ReadLine();
                        Console.Write("Enter last name: ");
                        string memberLastName = Console.ReadLine();
                        DatabaseHelper.AddNewMember(memberFirstName, memberLastName);
                        break;
                    case "5": // Record new loan
                        Console.WriteLine("\n--Record New Loan--\n");
                        int bookId;
                        int memberId;
                        Console.Write("Enter Book ID: ");
                        if (!int.TryParse(Console.ReadLine(), out bookId))
                        {
                            Console.WriteLine("\nInvalid Book ID.");
                            break ;
                        }
                        Console.Write("Enter Member ID: ");
                        if (!int.TryParse(Console.ReadLine(), out memberId))
                        {
                            Console.WriteLine("\nInvalid Member ID.");
                            break;
                        }
                        DatabaseHelper.RecordNewLoan(bookId, memberId);
                        break;
                    case "0": // Exit
                        Console.WriteLine("\nExiting program...");
                        return;
                    default:
                        Console.WriteLine("\nInvalid Choice.");
                        continue;
                }

                Console.WriteLine("\nPress any key to return to menu...");
                Console.ReadKey();
                
            }

        }

    }
}