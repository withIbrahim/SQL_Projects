


-- Create the Customers table

CREATE TABLE Customers2 (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Customers table

INSERT INTO Customers2 (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
-- Create the Branches table

CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
--------------------
-- Populate the Branches table

INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');

-- Create the Accounts table

CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers2 (CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
--------------------
-- Populate the Accounts table

INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);
--------------------
-- Create the Transactions table

CREATE TABLE Transactions_ (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
--------------------
-- Populate the Transactions table

INSERT INTO Transactions_ (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

--------------------------------------------------------------------------------

SELECT * FROM Customers2
SELECT * FROM Accounts
SELECT * FROM Branches
SELECT * FROM Transactions


/*
1. What are the names of all the customers who live in New York?
*/


	SELECT
		CustomerID,
		CONCAT(FirstName,' ',LastName) as Name,
		City
	FROM Customers2
	WHERE City = 'New York'


/*
2. What is the total number of accounts in the Accounts table?
*/
3

/*
3. What is the total balance of all checking accounts?
*/

	SELECT
		SUM(Balance) as Total_Balance_CheckingAC
	FROM Accounts
	WHERE AccountType ='Checking'


/*
4. What is the total balance of all accounts associated with customers who live in Los Angeles?
*/

	SELECT
		c.City AS City,
		SUM(a.Balance) AS Total_Balance
	FROM Accounts a JOIN Customers2 c
	ON a.CustomerID = c.CustomerID
	WHERE c.City = 'Los Angeles'
	GROUP BY c.City

  --Subqueary--

  SELECT
	SUM(Balance) as Total_Balance
  FROM Accounts 
  WHERE CustomerID IN (SELECT
					    c.CustomerID
					  FROM Customers2 c
					  WHERE c.City = 'Los Angeles'
					  )

/*
5. Which branch has the highest average account balance?
*/

	SELECT
		TOP 1
		b.BranchName,
		AVG(a.Balance) as Highest_Average_Balance
	FROM Accounts a JOIN Branches b 
		ON a.BranchID = b.BranchID
	GROUP BY 
		b.BranchName
	ORDER BY
		Highest_Average_Balance DESC


/*
6. Which customer has the highest current balance in their accounts?
*/

	SELECT
		TOP 1
		CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
		SUM(a.Balance) as Highest_Balance
	FROM Customers2 c JOIN  Accounts a
	ON c.CustomerID = a.CustomerID
	GROUP BY CONCAT(c.FirstName,' ',c.LastName)
	ORDER BY Highest_Balance DESC


/*
7. Which customer has made the most transactions in the Transactions table?
*/

--DENSE RANK

	SELECT 
		TOP 2
		c.FirstName,
		COUNT(t.TransactionID) AS Total_Transaction
	FROM Customers2 c JOIN Accounts a
	ON  c.CustomerID = a.CustomerID
	JOIN Transactions_ t ON a.AccountID = t.AccountID
	GROUP BY c.FirstName
	ORDER BY Total_Transaction DESC

	--CTE--

WITH ranks AS (
	SELECT 
		CONCAT(c.FirstName,' ',LastName) as Full_Name,
		COUNT(t.TransactionID) AS Total_Transactions,
		DENSE_RANK() OVER (ORDER BY t.TransactionID DESC ) AS RW_NO
	FROM Transactions_ t 
		JOIN Accounts a ON  t.AccountID = a.AccountID
		JOIN Customers2 c ON A.CustomerID=C.CustomerID  
	GROUP BY 
		CONCAT(c.FirstName,' ',LastName) 
	)

SELECT Full_Name,Total_Transactions
FROM ranks 
WHERE RW_NO=1
	



/*
8.Which branch has the highest total balance across all of its accounts?
*/

	SELECT
		TOP 1
		b.BranchName,
		SUM(a.Balance) AS Highest_Balance
	FROM Branches b JOIN Accounts a
	ON b.BranchID = a.BranchID
	GROUP BY b.BranchName
	ORDER BY Highest_Balance DESC



	SELECT
		b.BranchName,
		SUM(a.Balance) OVER (PARTITION BY b.BranchName ORDER BY a.Balance DESC) AS Highest_Balance
	FROM Branches b JOIN Accounts a
	ON b.BranchID = a.BranchID
	ORDER BY Highest_Balance DESC

/*
9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
*/
	
	SELECT
		TOP 1
		CONCAT(c.FirstName,' ',c.LastName) AS Customer_Name,
		SUM(a.Balance) as Total_Balance
	FROM Customers2 c JOIN Accounts a 
	ON c.CustomerID = a.CustomerID
	WHERE a.AccountType IN ('Checking', 'Savings')
	GROUP BY CONCAT(c.FirstName,' ',c.LastName)
	ORDER BY Total_Balance DESC



/*
10. Which branch has the highest number of transactions in the Transactions table?
*/


	SELECT
		TOP 2
		b.BranchName,
		COUNT(t.AccountID) as Total_Transactions
	FROM Branches b JOIN  Accounts a 
	ON b.BranchID = a.BranchID
	JOIN Transactions_ t on a.AccountID = t.AccountID
	GROUP BY b.BranchName
	ORDER BY Total_Transactions DESC


--- CTE---

	WITH RANKS AS (
			SELECT
			   b.BranchName,
			   COUNT(t.AccountID) as Total_Transactions,
			   DENSE_RANK() OVER (ORDER BY count(t.AccountID) DESC ) AS RW
			FROM Transactions_ t JOIN Accounts a
			ON t.AccountID = a.AccountID
			JOIN Branches b ON a.BranchID = b.BranchID
			GROUP BY b.BranchName
			)

	SELECT BranchName,Total_Transactions
	FROM RANKS
	WHERE RW = 1 
	ORDER BY Total_Transactions DESC

--------------------------------------	----------------------------------------------
