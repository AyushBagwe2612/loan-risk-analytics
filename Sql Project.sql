CREATE DATABASE loan_project;
USE loan_project;

SHOW TABLES;
SELECT * FROM loanapproval LIMIT 10;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    marital_status VARCHAR(20)
);

CREATE TABLE financials (
    customer_id INT,
    annual_income INT,
    credit_score INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    loan_amount INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers
SELECT applicant_id, age, gender, marital_status
FROM loanapproval;

INSERT INTO financials
SELECT applicant_id, annual_income, credit_score
FROM loanapproval;

INSERT INTO loans (customer_id, loan_amount)
SELECT applicant_id, loan_amount
FROM loanapproval;

SELECT * FROM customers LIMIT 5;
SELECT * FROM financials LIMIT 5;
SELECT * FROM loans LIMIT 5;

SELECT c.customer_id, f.annual_income, l.loan_amount
FROM customers c
JOIN financials f ON c.customer_id = f.customer_id
JOIN loans l ON c.customer_id = l.customer_id;

SELECT c.customer_id, l.loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
ORDER BY l.loan_amount DESC
LIMIT 5;

SELECT 
    c.customer_id,
    f.credit_score,
    CASE 
        WHEN f.credit_score < 600 THEN 'High Risk'
        WHEN f.credit_score BETWEEN 600 AND 750 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM customers c
JOIN financials f ON c.customer_id = f.customer_id;

SELECT 
    customer_id,
    loan_amount,
    RANK() OVER (ORDER BY loan_amount DESC) AS loan_rank
FROM loans;

SELECT 
    c.customer_id,
    f.annual_income,
    l.loan_amount,
    (l.loan_amount / f.annual_income) AS loan_ratio
FROM customers c
JOIN financials f ON c.customer_id = f.customer_id
JOIN loans l ON c.customer_id = l.customer_id;

