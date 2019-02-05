--DROP DATABASE TripService

-- DDL --
CREATE DATABASE TripService
GO

USE TripService
GO

CREATE TABLE Cities
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20) NOT NULL,
	CountryCode	CHAR(2) NOT NULL,
)
GO

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	CityId INT NOT NULL 
		CONSTRAINT FK_Hotels_Cities FOREIGN KEY (CityId) REFERENCES Cities(Id),
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(15,2)
)
GO

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(15,2) NOT NULL,
	Type NVARCHAR(20) NOT NULL,
	Beds INT NOT NULL,
	HotelId INT NOT NULL 
		CONSTRAINT FK_Rooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(Id),
)
GO

CREATE TABLE Trips
(
	Id INT PRIMARY KEY IDENTITY,
	RoomId INT NOT NULL
		CONSTRAINT FK_Trips_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(Id),
	BookDate DATETIME NOT NULL,
	ArrivalDate DATETIME NOT NULL,
	ReturnDate DATETIME NOT NULL,
	CancelDate DATETIME,

	CONSTRAINT CHK_IfBeforeArrivalDate CHECK(BookDate < ArrivalDate),
	CONSTRAINT CHK_IfBeforeReturnDate CHECK(ArrivalDate < ReturnDate),
)
GO

CREATE TABLE Accounts
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT NOT NULL
		CONSTRAINT FK_Accounts_Cities FOREIGN KEY (CityId) REFERENCES Cities(Id),
	BirthDate DATETIME NOT NULL,
	Email NVARCHAR(100) NOT NULL UNIQUE
)
GO

CREATE TABLE AccountsTrips
(
	AccountId INT NOT NULL
		CONSTRAINT FK_AccountsTrips_Accounts FOREIGN KEY (AccountId) REFERENCES Accounts(Id),
	TripId INT NOT NULL
		CONSTRAINT FK_AccountsTrips_Trips FOREIGN KEY (TripId) REFERENCES Trips(Id),
	Luggage INT NOT NULL
		CONSTRAINT CHK_Luggage CHECK(Luggage >= 0),
	Id INT PRIMARY KEY (AccountId, TripId)
)
GO
-- END OF DDL --

-- Insert 02.
INSERT INTO Accounts(FirstName, MiddleName, LastName, CityId, BirthDate, Email)
VALUES ('John', 'Smith', 'Smith', 34, '1975-07-21', 'j_smith@gmail.com'),
	   ('Gosho', NULL, 'Petrov', 11, '1978-05-16', 'g_petrov@gmail.com'),
	   ('Ivan', 'Petrovich', 'Pavlov', 59, '1849-09-26', 'i_pavlov@softuni.bg'),
	   ('Friedrich', 'Wilhelm', 'Nietzsche', 2, '1844-10-15', 'f_nietzsche@softuni.bg');

INSERT INTO Trips(RoomId, BookDate, ArrivalDate, ReturnDate, CancelDate)
VALUES (101, '2015-04-12',	'2015-04-14', '2015-04-20',	'2015-02-02'),
	   (102, '2015-07-07', '2015-07-15', '2015-07-22', '2015-04-29'),
	   (103, '2013-07-17', '2013-07-23', '2013-07-24', NULL),
	   (104, '2012-03-17',	'2012-03-31', '2012-04-01',	'2012-01-10'),
	   (109, '2017-08-07',	'2017-08-28', '2017-08-29',	NULL);
-- END OF INSERT --

-- Update 03.
UPDATE Rooms
SET Price *= 1.14
WHERE HotelId IN (5,7,9);
-- END OF UPDATE --

-- Delete 04.
DELETE 
FROM AccountsTrips
WHERE AccountId = 47;
-- END OF DELETE --

-- QUERYING --
-- 05. --
SELECT Id, Name
FROM Cities
WHERE CountryCode = 'BG'
ORDER BY Name ASC
-- END OF 05. --

-- 06. --
SELECT CONCAT(FirstName, ' ' + MiddleName, ' ', LastName) AS [Full Name],
	   DATEPART(YEAR, BirthDate) [BirthYear] 
FROM Accounts
WHERE DATEPART(YEAR, BirthDate) > 1991
ORDER BY BirthYear DESC, FirstName
-- END OF 06. --

-- 07. --
SELECT a.FirstName, a.LastName, FORMAT(a.BirthDate, 'MM-dd-yyyy'), c.Name [Hometown], a.Email FROM Accounts [a]
	JOIN Cities [c] ON c.Id = a.CityId
WHERE a.Email LIKE 'e%'
ORDER BY Hometown DESC
-- END OF 07. --

-- 08. --
SELECT c.Name [City], COUNT(h.Id) [Hotels]
FROM Cities [c]
	FULL JOIN Hotels [h] ON h.CityId = c.Id
GROUP BY c.Name
ORDER BY Hotels DESC, c.Name
-- END OF 08. --

