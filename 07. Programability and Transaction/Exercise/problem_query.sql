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

-- Problem 07.
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
BEGIN
	DECLARE @doesContain BIT = 1;
	DECLARE @index INT = 1;
	
	WHILE(@index < LEN(@word))
	BEGIN
		DECLARE @currentChar CHAR(1) = SUBSTRING(@word, @index, 1);
		DECLARE @indexOfFoundChar INT = CHARINDEX(@currentChar, @setOfLetters, 1)

		IF (@indexOfFoundChar = 0)
		BEGIN
			SET @doesContain = 0;
			BREAK;
		END

		SET @index += 1;
	END

	RETURN @doesContain;
END
GO

SELECT dbo.ufn_IsWordComprised('asd', 'deff')
GO
-- END --

-- Problem 08.
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT

	DELETE FROM EmployeesProjects WHERE EmployeeID IN(
		SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId
	)

	-- FUCK THIS PROBLEM IN PARTICULAR

	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId;

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId
	
	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees WHERE DepartmentID = @departmentId
GO
-- END --

USE Bank
GO
-- 09. --
CREATE PROC usp_GetHoldersFullName
AS
	SELECT CONCAT(FirstName, ' ' + LastName) [Full Name] FROM AccountHolders
GO
-- END --

-- 10. --
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@moreThanMoney DECIMAL(15,2))
AS
	SELECT FirstName, LastName
	FROM (
		SELECT FirstName, LastName, SUM(a.Balance) [Sum]
		FROM AccountHolders [ah]
			JOIN Accounts [a] ON a.AccountHolderId = ah.Id
		GROUP BY ah.Id, FirstName, LastName) [t]
	WHERE [Sum] > @moreThanMoney
	ORDER BY FirstName, LastName

EXEC usp_GetHoldersWithBalanceHigherThan 10000