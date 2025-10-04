CREATE TRIGGER ValidatePaymentAmount
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE expectedAmount DECIMAL(10,2);
    SELECT SUM(P.Price * OI.Quantity)
    INTO expectedAmount
    FROM OrderItems OI
    JOIN Products P ON OI.ProductID = P.ProductID
    WHERE OI.OrderID = NEW.OrderID;

    IF NEW.Amount <> expectedAmount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Incorrect payment amount!';
    END IF;
END;
