-- Test Data
INSERT INTO Customers (Name, Email, JoinDate) VALUES ('Test User', 'test@example.com', CURDATE());
INSERT INTO Products (ProductName, Price, Stock) VALUES ('Laptop', 1000.00, 10);

-- Run Procedure
CALL PlaceOrder(1, 1, 2);  -- Should succeed

-- Should throw an error
CALL PlaceOrder(1, 1, 100);  -- Expect: 'Insufficient stock!'
