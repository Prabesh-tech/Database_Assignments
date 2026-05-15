/*------- DROP STATEMENTS -----------*/

/*--- Drop customers table ---*/
DROP TABLE customers;

/*----- Drop bill_addresses object table ----*/
DROP TABLE bill_addresses;

/*---- Drop invoice_address_type object type ----------*/
DROP TYPE invoice_address_type;

/*--------- Commented to avoid impacting sites table --------*/

/*----- DROP TABLE states;
DROP TYPE state_type; ----*/

/*------- Drop adverts table -------*/
DROP TABLE adverts PURGE;

/*------- Drop prospective_customers table -------*/
DROP TABLE prospective_customers PURGE;

/*------ Drop nested table type --------*/
DROP TYPE social_media_table_type;

/*------- Drop varray type ---------*/
DROP TYPE social_media_varray_type;

/*---------- Drop object type ---------*/
DROP TYPE social_media_type;










/*-------- DEFINING OBJECT TYPES ----------*/

CREATE OR REPLACE TYPE invoice_address_type AS OBJECT(
    street VARCHAR2(25),
    city VARCHAR2(25),
    country VARCHAR2(25)
);

SHOW ERRORS;




/*------- USING OBJECT COLUMNS IN RELATIONAL TABLES --------*/

CREATE TABLE customers(
    customer_id NUMBER(6),
    customer_name VARCHAR2(25),
    invoice_address invoice_address_type
);

DESC customers;




/*-------- DEFINING OBJECT TABLES ------*/

CREATE TABLE bill_addresses OF invoice_address_type;
DESC bill_addresses;




/*-------- REFERENCING OBJECT TABLES IN RELATIONAL TABLES -----------*/

/*----- Drop old customers table ---------*/
DROP TABLE customers;



/*------ Recreate customers with REF column -------*/

CREATE TABLE customers(
    customer_id NUMBER(6),
    customer_name VARCHAR2(25),
    invoice_address REF invoice_address_type
        SCOPE IS bill_addresses
);

DESC customers;












/*------ ALTERING RELATIONAL TABLES TO REFERENCE OBJECT TABLES ------*/

/*------ Create state_type object ------*/

CREATE OR REPLACE TYPE state_type AS OBJECT(
    state VARCHAR2(25),
    country VARCHAR2(25)
);

SHOW ERRORS;

/* View object structure */
DESC state_type;

/* Create object table */

CREATE TABLE states OF state_type;

/* Alter sites table */

ALTER TABLE sites
ADD (
    state_ref REF state_type
    SCOPE IS states
);

DESC sites;











/*--------- QUERY USER_OBJECTS ---------*/

COLUMN object_type FORMAT A25;
COLUMN object_name FORMAT A25;

SELECT object_type, object_name
FROM user_objects;





/*---- DEFINING VARRAYS ---------*/

/*------ Create social_media_type object --------*/

CREATE OR REPLACE TYPE social_media_type AS OBJECT(
    media_name VARCHAR2(25),
    contact VARCHAR2(50)
);

SHOW ERRORS;





/*------- Create VARRAY -------*/

CREATE TYPE social_media_varray_type
AS VARRAY(50) OF social_media_type;

SHOW ERRORS;






/*------- USING VARRAYS IN RELATIONAL TABLES -----------*/

CREATE TABLE prospective_customers(
    prospective_customer_id NUMBER(6),
    company_name VARCHAR2(50),
    contact_name VARCHAR2(25),
    social_media_available social_media_varray_type
);

DESC prospective_customers;






/*-------- DEFINING NESTED TABLES --------------*/

/*-------- Create nested table type -----------*/

CREATE TYPE social_media_table_type
AS TABLE OF social_media_type;

SHOW ERRORS;

/*----- Describe nested table type ----------*/
DESC social_media_table_type;












/*-------- CREATE RELATIONAL TABLE WITH NESTED TABLE ---------*/

CREATE TABLE adverts(
    advert_id NUMBER(6),
    advert_title VARCHAR2(50),
    description VARCHAR2(25),
    social_media_used social_media_table_type
)
NESTED TABLE social_media_used
STORE AS social_media_nested_table;

DESC adverts;


















Answers to Workbook Questions



Q1. What datatype is the invoice_address column?
=> INVOICE_ADDRESS_TYPE

Q2. Object type name and object table name
=>
    Item	                        Name
    Object Type	           invoice_address_type
    Object Table	           bill_addresses

Q3. What will be the names of your object_type and object_table?
=>  
    Item	                        Name
    Object Type	            invoice_address_type
    Object Table	            bill_addresses

Q4. What are the 2 most useful columns in USER_OBJECTS?
=>      OBJECT_TYPE
        OBJECT_NAME

Q5. What is the command to view your types?
=>  SELECT object_type, object_name
    FROM user_objects;

Q6. Command to format object_type and object_name columns to 25 each?
=>  COLUMN object_type FORMAT A25;
    COLUMN object_name FORMAT A25;

Q7. How is the VARRAY stored, i.e., what is its type?
=>  It is stored as:
    SOCIAL_MEDIA_VARRAY_TYPE

Q8. What is the command to describe your nested table type?
=>  DESC social_media_table_type;

Q9. Difference between nested table and bill_addresses object table?
=>   1. bill_addresses is an object table
     2. social_media_table_type is a nested table type

    Object tables store objects directly as rows, while nested tables are collection datatypes stored inside another table.


Q10. Describe adverts – what are the types used?
=>  Column                  Type
    advert_id	          NUMBER(6)
    advert_title	     VARCHAR2(50)
    description        	 VARCHAR2(25)
    social_media_used	SOCIAL_MEDIA_TABLE_TYPE

Q11. Additional types used in adverts and prospective_customers
=>  social_media_type
    social_media_varray_type
    social_media_table_type

Q12. Correct order of DROP statements?
=>
    DROP TABLE adverts PURGE;
    DROP TABLE prospective_customers PURGE;
    DROP TYPE social_media_table_type;
    DROP TYPE social_media_varray_type;
    DROP TYPE social_media_type;