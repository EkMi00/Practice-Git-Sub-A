/*******************

  Create the schema

********************/

CREATE TABLE IF NOT EXISTS customers (
	ssn CHAR(11) PRIMARY KEY,
	first_name VARCHAR(32) NOT NULL ,
	last_name VARCHAR(32) NOT NULL ,
	country VARCHAR(16) NOT NULL
);

CREATE TABLE IF NOT EXISTS credit_cards (
	ssn CHAR(11) NOT NULL REFERENCES customers(ssn), 
	number VARCHAR(20) PRIMARY KEY, 
	type VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS merchants (
	code CHAR(10) PRIMARY KEY,
	name VARCHAR(64) NOT NULL,
	country VARCHAR(16) NOT NULL
);


CREATE TABLE IF NOT EXISTS transactions(
    identifier INTEGER PRIMARY KEY,  
    number VARCHAR(20) NOT NULL REFERENCES credit_cards(number),  
    code CHAR(10) NOT NULL REFERENCES merchants(code),  
    datetime TIMESTAMP NOT NULL,  
    amount NUMERIC NOT NULL
);
