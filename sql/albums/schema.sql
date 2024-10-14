DROP SCHEMA IF EXISTS records;
CREATE SCHEMA records;
USE records;

CREATE TABLE IF NOT EXISTS customers (
	customer_id CHAR(11) PRIMARY KEY,
	name VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS albums (
	customer_id CHAR(11) NOT NULL REFERENCES customers(customer_id), 
	album_id VARCHAR(20) PRIMARY KEY NOT NULL, 
	genre VARCHAR(32) NOT NULL
);


USE records;
INSERT INTO customers (customer_id, name) VALUES ('111-11-1111', 'John');
INSERT INTO customers (customer_id, name) VALUES ('608-71-2352', 'Tabatha');
INSERT INTO customers (customer_id, name) VALUES ('332-36-3186', 'Codi');
INSERT INTO customers (customer_id, name) VALUES ('137-54-8553', 'Kellina');
-- INSERT INTO customers (customer_id, name) VALUES ('308-56-5739', 'Gustavus');
-- INSERT INTO customers (customer_id, name) VALUES ('436-10-7663', 'Barnebas');
-- INSERT INTO customers (customer_id, name) VALUES ('893-24-5769', 'Ulick');
-- INSERT INTO customers (customer_id, name) VALUES ('767-18-0531', 'Margareta');
-- INSERT INTO customers (customer_id, name) VALUES ('683-88-3286', 'Sheelah');
 
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '001', 'pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '002', 'hip-hop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '003', 'hip-hop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '004', 'R&B');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '005', 'R&B');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('608-71-2352', '006', 'k-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('608-71-2352', '007', 'mando-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('608-71-2352', '008', 'mando-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('608-71-2352', '009', 'pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '010', 'hip-hop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '011', 'blues');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '012', 'country');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '013', 'k-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '014', 'k-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('111-11-1111', '015', 'hip-hop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('608-71-2352', '016', 'k-pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('332-36-3186', '017', 'pop');
INSERT INTO albums (customer_id, album_id, genre) VALUES ('137-54-8553', '018', 'pop');


USE records;
SELECT * 
FROM customers c 
CROSS JOIN albums a
ON c.customer_id = a.customer_id;

USE records;
SELECT a.customer_id, a.genre, 
COUNT(a.album_id) album_count
FROM albums a 
GROUP BY a.customer_id, a.genre;

USE records;
SELECT gs.genre,
COUNT(DISTINCT gs.customer_id) distinct_customers,
AVG(gs.album_count) avg_albums_per_cust
FROM (
    SELECT a.customer_id, a.genre, 
    COUNT(a.album_id) album_count
    FROM albums a 
    GROUP BY a.customer_id, a.genre
) AS gs
GROUP BY gs.genre;

USE records;
SELECT a.genre, 
COUNT(DISTINCT a.customer_id) distinct_customers,
COUNT(a.album_id)/COUNT(DISTINCT a.customer_id) avg_albums_per_cust
FROM albums a 
GROUP BY a.genre;
