CREATE VIEW CustomerSummary AS
SELECT
    Customer.customerId,
    innerquery.modelName,
    SUM(innerquery.rentalDays) AS daysRented,
    innerquery.taxYear,
    SUM(innerquery.rentalCost) AS rentalCost
FROM Customer 
JOIN (
    SELECT
        rc.customerId,
        CASE
            WHEN pm.modelName IS NULL THEN 'unknown model'
            ELSE pm.modelName
        END AS modelName,
        rc.rentalDays,
        CASE
    	WHEN strftime('%m-%d', rc.dateBack) <= '06-30' THEN
        	CAST(strftime('%Y', rc.dateBack, '-1 year') AS TEXT) || '/' || SUBSTR(CAST(strftime('%Y', rc.dateBack) AS TEXT), 3, 2)
    	ELSE
        	CAST(strftime('%Y', rc.dateBack) AS TEXT) || '/' || SUBSTR(CAST(strftime('%Y', rc.dateBack, '+1 year') AS TEXT),3,2)
		END AS taxYear,
        rc.rentalCost
    FROM rentalContract rc
    LEFT JOIN Phone p ON rc.IMEI = p.IMEI
    LEFT JOIN PhoneModel pm ON p.modelNumber = pm.modelNumber
    WHERE rc.dateBack IS NOT NULL
) innerquery ON Customer.customerId = innerquery.customerId
GROUP BY Customer.customerId, innerquery.modelName, innerquery.taxYear;