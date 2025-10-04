DELIMITER //

CREATE PROCEDURE PlaceOrder (
    IN p_CustomerID INT,
    IN p_ProductID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE currentStock INT;
    DECLARE totalAmount DECIMAL(10,2);
    
    -- Check product availability
    SELECT Stock INTO currentStock FROM Products WHERE ProductID = p_ProductID;
    
    IF currentStock < p_Quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock!';
    END IF;

    -- Create Order
    INSERT INTO Orders (CustomerID, OrderDate) VALUES (p_CustomerID, CURDATE());
    SET @newOrderID = LAST_INSERT_ID();

    -- Add Order Item
    INSERT INTO OrderItems (OrderID, ProductID, Quantity)
    VALUES (@newOrderID, p_ProductID, p_Quantity);

    -- Calculate Amount
    SELECT Price * p_Quantity INTO totalAmount FROM Products WHERE ProductID = p_ProductID;

    -- Insert Payment
    INSERT INTO Payments (OrderID, Amount, PaymentDate, Status)
    VALUES (@newOrderID, totalAmount, CURDATE(), 'Paid');

    -- Update Stock
    UPDATE Products
    SET Stock = Stock - p_Quantity
    WHERE ProductID = p_ProductID;
END //

DELIMITER ;
