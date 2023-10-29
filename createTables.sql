-- Creation of PhoneModel Table
CREATE TABLE PhoneModel (
    modelNumber TEXT,
    modelName TEXT,
    storage INTEGER,
    colour TEXT,
    baseCost REAL,
    dailyCost REAL,
    constraint PhoneModel_PK primary key(modelNumber)
  	
);

-- Creation of Customer Table
CREATE TABLE Customer (
    customerId INTEGER,
    customerName TEXT,
    customerEmail TEXT,
    constraint Customer_PK primary key(customerId)
);

-- Creation of Phone Table 
CREATE TABLE Phone (
    modelNumber TEXT,
    modelName TEXT,
    IMEI TEXT,
    CHECK (
        LENGTH(IMEI) = 15 AND
        IMEI GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND
        (
            -- Calculate the sum of the digits in odd-numbered positions and Luhn codes for even-numbered positions
            (
                (CAST(SUBSTR(IMEI, 1, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 3, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 5, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 7, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 9, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 11, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 13, 1) AS INTEGER) + 
                 CAST(SUBSTR(IMEI, 15, 1) AS INTEGER)
                ) +
                (
                    CAST(SUBSTR(IMEI, 2, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 2, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 4, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 4, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 6, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 6, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 8, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 8, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 10, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 10, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 12, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 12, 1) AS INTEGER) * 2 / 10 +
                    CAST(SUBSTR(IMEI, 14, 1) AS INTEGER) * 2 % 10 +
                    CAST(SUBSTR(IMEI, 14, 1) AS INTEGER) * 2 / 10
                )
            ) % 10 = 0
        )
    ),
    CONSTRAINT Phone_PK PRIMARY KEY(IMEI),
  	CONSTRAINT Phone_FK1 FOREIGN KEY(modelNumber) REFERENCES PhoneModel(modelNumber),
   	CONSTRAINT Phone_FK2 FOREIGN KEY(modelName) REFERENCES PhoneModel(modelName)
);

-- Creation of rentalContract Table
CREATE TABLE rentalContract (
    customerId INTEGER,
    IMEI TEXT,
    dateOut TEXT,
    dateBack TEXT,
    rentalCost REAL,
  	rentalDays INTEGER,
    constraint rentalContract_FK1 foreign key(IMEI) references Phone(IMEI),
    constraint rentalContract_FK2 foreign key(customerId) references Customer(customerId)
  
);