USE credit;
SELECT cc.type, COUNT(cc.number) merchants,
SUM(t.amount) amount_per_merchants
FROM credit_cards cc, 
merchants m, 
transactions t
WHERE cc.number = t.number
AND m.code = t.code
GROUP BY cc.type;

USE credit;
SELECT cc.type, SUM(t.amount) 
FROM credit_cards cc, 
merchants m, 
transactions t
WHERE cc.number = t.number
AND m.code = t.code
AND cc.type = 'bankcard'; 
-- Find the total number of merchants per credit cards type, and
-- and the avg transaction per merchants

USE credit;
SELECT *
FROM customers c1
WHERE c1.ssn < "111-11-1111"
UNION
SELECT *
FROM customers c2
WHERE c2.ssn >= "111-11-1111";

USE credit;
SELECT c.ssn, c.first_name , c.last_name, c.country, 
cc.number, cc.type,
m.code, m.name, m.country,
t.identifier, t.datetime, t.amount
FROM customers c, credit_cards cc, merchants m, transactions t
WHERE t.number = cc.number
AND t.code = m.code
AND cc.ssn = c.ssn
LIMIT 1000;

-- Q3 Give the SQL code for an insertion to the 
-- table merchants that violates a not null constraint
INSERT INTO merchants (code, name, country) VALUES ('98-1479529', 'Walt, Olson and Mertz', NULL);
-- ERROR: null value in column "country" of relation "merchants" violates not-null constraint

-- Q4 Give the SQL code for an update to the 
-- table transactions that violates a constraint 
-- on the table merchants.
UPDATE merchants SET name = NULL;
-- ERROR: null value in column "name" of relation "merchants" violates not-null constraint

-- Q5 Give the SQL code for an insertion into the
-- table merchants that violates a primary key constraint
INSERT INTO merchants (code, name, country) VALUES ('88-1479529', 'Walt, Olson and Mertz', 'Singapore');
-- ERROR: duplicate key value violates unique constraint "merchants_pkey"

-- Q6 Give the SQL code for an update to the table 
-- transactions that violates a primary key constraint
UPDATE transactions SET identifier = 2 WHERE identifier = 1;
-- ERROR: duplicate key value violates unique constraint "transactions_pkey"

-- Q7 Find the last and first names of the different 
-- Singaporean customers. Print the result in alphabetical order
-- of the last and first names.
USE credit;
SELECT last_name, first_name
FROM customers c
ORDER BY last_name, first_name;

-- Q8 For each Singaporean customer, find his or her 
-- first and last name and total expenditure. Implicitly 
-- ignore customers who did not use their credit cards or 
-- do not have a credit card.
USE credit;
SELECT c.first_name, c.last_name, SUM(t.amount)
FROM customers c, transactions t, credit_cards cc
WHERE cc.ssn = c.ssn
AND t.number = cc.number
GROUP BY c.ssn;

-- Q9 Find the social security number of the different customers 
-- who purchased something on Christmas day 2017 with their Visa
-- credit card (the credit card type is "visa")
SELECT DISTINCT c.ssn
FROM customers c, credit_cards cc, transactions t
WHERE cc.ssn = c.ssn
AND t.number = cc.number
AND DATE(t.datetime) = DATE('2017-12-25')
AND cc.type = 'visa';

-- Q10 For each customer and for each credit card type, find how
-- many credit cards of that type the customer owns. Print the 
-- customer's social security number, the credit card type and 
-- the number of credit cards of the given type owned. Print zero
-- if a customer does not own a credit card of the given type.
USE credit;
SELECT table1.ssn, table1.type, 
(CASE WHEN table2.count_type IS NULL
THEN 0 ELSE count_type END) AS count
FROM

(SELECT c.ssn, cc2.type
FROM customers c, 
(SELECT DISTINCT(cc1.type) 
FROM credit_cards cc1) AS cc2 
ORDER BY c.ssn) AS table1

LEFT OUTER JOIN

(SELECT c.ssn, cc.type, 
COUNT(cc.type) AS count_type
FROM customers c, credit_cards cc
WHERE cc.ssn = c.ssn
GROUP BY c.ssn, cc.type
ORDER BY c.ssn) AS table2

ON table1.ssn = table2.ssn
AND table1.type = table2.type
ORDER BY table1.ssn, table1.type;

-- Shorter
SELECT c1.ssn, c1.type, COUNT(cc1.number)
FROM
(SELECT DISTINCT c2.ssn, cc2.type
FROM customers c2, credit_cards cc2) AS c1
LEFT OUTER JOIN credit_cards cc1 
ON c1.ssn = cc1.ssn 
AND c1.type = cc1.type
GROUP BY c1.ssn, c1.type
ORDER BY c1.ssn, c1.type;

-- Q11 Find the code and name of different merchants who did
-- not entertain transactions for every type of credit card.
-- Do not use aggregate functions.

-- Nested Method (Late)
USE credit;
SELECT DISTINCT m.code, m.name
FROM merchants m, credit_cards cc1 
WHERE NOT EXISTS (
    SELECT *
    FROM credit_cards cc2
    WHERE cc1.type = cc2.type
    AND EXISTS (
        SELECT *
        FROM transactions t
        WHERE t.number = cc2.number
        AND t.code = m.code) )
ORDER BY m.code, m.name;
-- Subquery selects those merchants who did entertain 
-- transactions for (every?) type of credit card 
    
-- Outer Join Method (Submitted)
SELECT DISTINCT table1.code, table1.name
FROM

(SELECT DISTINCT m1.code, m1.name, cc1.type
FROM credit_cards cc1, merchants m1
ORDER BY m1.code, cc1.type) AS table1

LEFT OUTER JOIN

(SELECT DISTINCT m2.code, cc2.type
FROM credit_cards cc2, merchants m2, transactions t2
WHERE t2.number = cc2.number
AND t2.code = m2.code
ORDER BY m2.code, cc2.type) AS table2

ON table1.code = table2.code
AND table1.type = table2.type
WHERE table2.type IS NULL
ORDER BY table1.code, table1.name;


-- Aggregate Method (For Checking)
SELECT m.code, m.name
FROM merchants m, credit_cards cc, transactions t
WHERE t.number = cc.number
AND t.code = m.code
GROUP BY m.code
HAVING COUNT(DISTINCT cc.type) < 16
ORDER by m.code, m.name;


-- -- Customer without credit card: John Doe
-- SELECT c.ssn
-- FROM customers c
-- EXCEPT
-- SELECT c.ssn
-- FROM customers c, credit_cards cc
-- WHERE c.ssn = cc.ssn


-- Q12 Find the first and last names of the different customers
-- from Thailand who do not have a JCB credit card (the credit
-- card type is "jcb"). Propose five (5) different SQL queries

-- Method 1
(SELECT DISTINCT c.first_name, c.last_name
FROM customers c, credit_cards cc, transactions t
WHERE t.number = cc.number
AND cc.ssn = c.ssn
AND c.country = 'Thailand'
AND cc.type != 'jcb')
UNION
(SELECT c1.first_name, c1.last_name
FROM customers c1 
WHERE c1.country = 'Thailand'
EXCEPT
SELECT c2.first_name, c2.last_name
FROM customers c2, credit_cards cc2
WHERE c2.ssn = cc2.ssn);

-- Method 2
((SELECT DISTINCT c.first_name, c.last_name
FROM customers c, credit_cards cc, transactions t
WHERE t.number = cc.number
AND cc.ssn = c.ssn
AND c.country = 'Thailand')
INTERSECT
(SELECT DISTINCT c.first_name, c.last_name
FROM customers c, credit_cards cc, transactions t
WHERE t.number = cc.number
AND cc.ssn = c.ssn
AND cc.type != 'jcb'))
UNION
(SELECT c.first_name, c.last_name
FROM customers c
WHERE c.country = 'Thailand'
EXCEPT
SELECT c.first_name, c.last_name
FROM customers c, credit_cards cc
WHERE c.ssn = cc.ssn );

-- Method 3
(SELECT DISTINCT c.first_name, c.last_name
FROM customers c
WHERE c.ssn IN (
    SELECT cc.ssn
    FROM credit_cards cc
    WHERE c.ssn = cc.ssn
    AND c.country = 'Thailand'
    AND cc.type != 'jcb'
))
UNION
(SELECT c.first_name, c.last_name
FROM customers c
WHERE c.country = 'Thailand'
EXCEPT
SELECT c.first_name, c.last_name
FROM customers c, credit_cards cc
WHERE c.ssn = cc.ssn );

-- Method 4
(SELECT DISTINCT c.first_name, c.last_name
FROM customers c
WHERE EXISTS (
    SELECT cc.type
    FROM credit_cards cc
    WHERE c.ssn = cc.ssn
    AND c.country = 'Thailand'
    AND cc.type != 'jcb'
))
UNION
(SELECT c.first_name, c.last_name
FROM customers c
WHERE c.country = 'Thailand'
EXCEPT
SELECT c.first_name, c.last_name
FROM customers c, credit_cards cc
WHERE c.ssn = cc.ssn );

-- Method 5
(SELECT DISTINCT c.first_name, c.last_name
FROM customers c
WHERE c.ssn = ANY (
    SELECT cc.ssn
    FROM credit_cards cc
    WHERE c.ssn = cc.ssn
    AND c.country = 'Thailand'
    AND cc.type != 'jcb'
))
UNION
(SELECT c.first_name, c.last_name
FROM customers c
WHERE c.country = 'Thailand'
EXCEPT
SELECT c.first_name, c.last_name
FROM customers c, credit_cards cc
WHERE c.ssn = cc.ssn );