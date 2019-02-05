USE SoftUni
GO

-- Problem 01.
CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000
AS
  SELECT FirstName [First Name], LastName [LastName]
  FROM Employees
  WHERE Salary > 35000
GO

EXEC usp_GetEmployeesSalaryAbove35000
GO
-- END --

-- Problem 02.
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber(@salaryAboveToSearch DECIMAL(18, 2))
AS
  SELECT FirstName, LastName
  FROM Employees
  WHERE Salary > @salaryAboveToSearch
GO

EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO
-- END --

-- Problem 03.
CREATE OR ALTER PROC usp_GetTownsStartingWith(@townName VARCHAR(50))
AS
  SELECT [Name]
  FROM Towns
  WHERE [Name] LIKE @townName + '%'
GO

EXEC usp_GetTownsStartingWith 'b'
GO
-- END --

-- Problem 04.
CREATE OR ALTER PROC usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
  SELECT e.FirstName [First Name], e.LastName [Last Name]
  FROM Employees [e]
      JOIN Addresses [a] ON e.AddressID = a.AddressID
      JOIN Towns [t] ON a.TownID = t.TownID
  WHERE t.Name = @townName
GO

EXEC usp_GetEmployeesFromTown 'Sofia'
GO
-- END --

-- Problem 05.
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10) AS
BEGIN
    DECLARE @output VARCHAR(10);

    IF (@salary < 30000)
    BEGIN
      SET @output = 'Low';
    END

    ELSE IF (@salary BETWEEN 30000 AND 50000)
    BEGIN
      SET @output = 'Average';
    END

    ELSE
    BEGIN
      SET @output = 'High';
    END

    RETURN @output
END
GO

EXEC ufn_GetSalaryLevel 45000
GO
-- END --

-- Problem 06.
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@level VARCHAR(10))
AS
  SELECT FirstName
       ,LastName
  FROM Employees
  WHERE dbo.ufn_GetSalaryLevel(Salary) = @level
GO

EXEC usp_EmployeesBySalaryLevel 'High'
GO
-- END --

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
BEGIN
    DECLARE @myBool BIT;

    IF(1 = 1)
    BEGIN
      SET @myBool = 1
    END	

    ELSE
    BEGIN
      SET @myBool = 0;
    END

    RETURN @myBool;

END
GO
