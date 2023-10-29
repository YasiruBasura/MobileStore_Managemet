CREATE TRIGGER CalculateRentalCost
AFTER UPDATE OF dateBack ON rentalContract
FOR EACH ROW
WHEN NEW.dateBack IS NOT NULL AND OLD.dateBack IS NULL
BEGIN
  
  UPDATE rentalContract 
  SET
    rentalDays = CAST(julianday(NEW.dateBack) - julianday(NEW.dateOut) + 1 AS INTEGER),
    rentalCost = (
      SELECT (PhoneModel.baseCost + PhoneModel.dailyCost * (julianday(NEW.dateBack) - julianday(NEW.dateOut) + 1))
      FROM Phone
      JOIN PhoneModel ON Phone.modelNumber = PhoneModel.modelNumber
      WHERE Phone.IMEI = NEW.IMEI
    )
  WHERE customerId = NEW.customerId AND IMEI = NEW.IMEI;
END;