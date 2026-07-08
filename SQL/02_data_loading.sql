USE sales_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/Dataset/Superstore_Clean.csv'
INTO TABLE superstore_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


SELECT COUNT(*) from superstore_raw;
