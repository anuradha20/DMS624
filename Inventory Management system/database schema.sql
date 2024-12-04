CREATE TABLE Inventory (
    TireID INT AUTO_INCREMENT PRIMARY KEY,
    TireType VARCHAR(50) NOT NULL,
    QuantityInStock INT NOT NULL,
    ReorderPoint INT NOT NULL,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    TireID INT,
    QuantityOrdered INT NOT NULL,
    OrderDate DATE NOT NULL,
    ExpectedDeliveryDate DATE NOT NULL,
    FOREIGN KEY (TireID) REFERENCES Inventory(TireID)
);
CREATE TABLE UsageLog (
    UsageID INT AUTO_INCREMENT PRIMARY KEY,
    TireID INT,
    BusID INT NOT NULL,
    ReplacementDate DATE NOT NULL,
    MileageAtReplacement INT NOT NULL,
    FOREIGN KEY (TireID) REFERENCES Inventory(TireID)
);
CREATE TABLE Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactPhone VARCHAR(15),
    ContactEmail VARCHAR(100)
);
CREATE TABLE Buses (
    BusID INT AUTO_INCREMENT PRIMARY KEY,
    BusNumber VARCHAR(20) NOT NULL,
    Model VARCHAR(50),
    Capacity INT
);
