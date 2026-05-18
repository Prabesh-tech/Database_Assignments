/*-----  INSERTING DATA INTO AN OBJECT TABLE ---------*/

INSERT INTO bill_addresses(street, city, country)
VALUES ('54 FESTIVE ROAD', 'NORTHAMPTON', 'UK');

INSERT INTO bill_addresses(street, city, country)
VALUES ('30 ENGLISH STREET', 'BEDFORD', 'UK');

/*------ View contents -------*/
SELECT * FROM bill_addresses;



/*------- INSERTING DATA INTO A TABLE WITH A REF -----*/

INSERT INTO customers(customer_id, customer_name, invoice_address)
SELECT 1,
       'RAM SHARMA',
       REF(b)
FROM bill_addresses b
WHERE b.street = '54 FESTIVE ROAD';

/*----- View customers -----*/
SELECT * FROM customers;



/*------ UPDATING DATA IN A TABLE WITH A REF -----*/

/*------- Insert BIHAR into states first -------*/

INSERT INTO states(state, country)
VALUES ('BIHAR', 'INDIA');


/*------ Update sites table with reference ------*/

UPDATE sites s
SET s.state_ref = (
    SELECT REF(st)
    FROM states st
    WHERE st.state = 'BIHAR'
)
WHERE s.site_id = 1;

/*----- Check update -------*/
SELECT site_id, state_ref
FROM sites;





/*------- INSERTING DATA INTO OBJECT COLUMNS ---------------*/

/*------- Recreate customers table with object column ----*/

DROP TABLE customers;

CREATE TABLE customers(
    customer_id NUMBER(6),
    customer_name VARCHAR2(25),
    invoice_address invoice_address_type
);

DESC customers;


/*------ Insert into object column ---------*/

INSERT INTO customers
VALUES (
    2,
    'SAM SHARMA',
    invoice_address_type(
        '1 MY WAY',
        'LUTON',
        'UK'
    )
);

/*------ View contents --------*/
SELECT * FROM customers;



/*--------- INSERTING DATA INTO OBJECT COLUMNS AND TABLES --------*/

/*------ Insert into states ------------*/

INSERT INTO states(state, country)
VALUES ('ALBERTA', 'CANADA');

INSERT INTO states(state, country)
VALUES ('VICTORIA', 'AUSTRALIA');

INSERT INTO states(state, country)
VALUES ('QUEENSLAND', 'AUSTRALIA');

INSERT INTO states(state, country)
VALUES ('DELHI', 'INDIA');


/*---------- View sites structure -----------------*/
DESC sites;


/*--------- Insert into sites ---------------*/

INSERT INTO sites(site_id, address, state_ref)
SELECT 100,
       invoice_address_type(
           '45 QUEEN STREET',
           'BRISBANE',
           'AUSTRALIA'
       ),
       REF(st)
FROM states st
WHERE st.state = 'QUEENSLAND';





/*--------- BONUS ACTIVITY INSERT AND UPDATE -------------*/

/*--------- Insert fictional site ----------*/

INSERT INTO sites(site_id, address)
VALUES (
    101,
    invoice_address_type(
        '999 DREAM ROAD',
        'CALGARY',
        'CANADA'
    )
);


/*-------- Update with ALBERTA reference ----------*/

UPDATE sites s
SET s.state_ref = (
    SELECT REF(st)
    FROM states st
    WHERE st.state = 'ALBERTA'
)
WHERE s.site_id = 101;



/*----------- INSERTING INTO TABLES WITH VARRAY TYPES ---------------*/

/*---------- Insert first prospective customer --------------*/

INSERT INTO prospective_customers(
    prospective_customer_id,
    company_name,
    contact_name,
    social_media_available
)
VALUES (
    80000,'ABC TECH','RAJ SHARMA',
    social_media_varray_type(
        social_media_type(
            'FACEBOOK','facebook.com/abctech'
        ),
        social_media_type(
            'INSTAGRAM','instagram.com/abctech'
        ),
        social_media_type(
            'TWITTER','@abctech'
        )
    )
);


/*--------- Insert second prospective customer -------------*/

INSERT INTO prospective_customers(
    prospective_customer_id,
    company_name,
    contact_name,
    social_media_available
)
VALUES (
    80001,'GLOBAL SOLUTIONS','SITA KAFLE',
    social_media_varray_type(
        social_media_type(
            'LINKEDIN','linkedin.com/global'
        ),
        social_media_type(
            'YOUTUBE','youtube.com/global'
        ),
        social_media_type(
            'TIKTOK','@globalsolutions'
        )
    )
);


/*----------- INSERTING INTO TABLES WITH NESTED TABLES ---------*/

INSERT INTO adverts(
    advert_id,
    advert_title,
    description,
    social_media_used
)
VALUES (
    90000,'SUMMER SALE','DISCOUNT OFFER',
    social_media_table_type(
        social_media_type(
            'FACEBOOK','facebook.com/summersale'
        ),
        social_media_type(
            'INSTAGRAM','instagram.com/summersale'
        ),
        social_media_type(
            'TWITTER','@summersale'
        )
    )
);

/*------- View adverts ---------*/
SELECT * FROM adverts;







/*----------- BIG TRICKY INSERT – MULTIPLE TYPES ------------*/

INSERT INTO sites(site_id, address, state_ref)
SELECT 102,
       invoice_address_type(
           '500 CITY ROAD','MELBOURNE','AUSTRALIA'
       ),
       REF(st)
FROM states st
WHERE st.state = 'VICTORIA';






/*------------- BONUS TRICKY INSERT AND UPDATE -----------*/

/*----------- Insert without classroom ----------------*/

INSERT INTO sites(site_id, address)
VALUES (
    103,
    invoice_address_type(
        '10 FUTURE ROAD','DELHI','INDIA'
    )
);


/*---- Example update ----------*/

UPDATE sites
SET classroom = 'A101'
WHERE site_id = 103;






























Answers to Workbook Questions




Q1. What do you get? Why does it look like that?
=>  0000220208A6B6F8
    This is a REF value (object reference pointer) to the row stored in the bill_addresses object table, not the actual address itself.


Q2. Which table will you need to insert into first?
=>  states
    Because the sites table references objects stored in states.


Q3. What command do you use instead of INSERT?
=>  UPDATE


Q4. What does the update statement do?
=>  It updates the state_ref column in the sites table so that it references the correct object row in the states object table.

Q5. Did inserting into object columns work? How can you tell?
=>  Yes
    SELECT * FROM customers;   //Verification
    INVOICE_ADDRESS_TYPE('1 MY WAY','LUTON','UK')    // Object data appears 

Q6. What are the data types used in sites?
=>
    Column	        Datatype
    site_id	          NUMBER
    address	       invoice_address_type
    state_ref	       REF state_type

Q7. Which 3 columns will you need to insert into?
=>  site_id
    address
    state_ref


Q8. Did the nested table insert work? How can you tell?
=>  Yes.
    SELECT * FROM adverts;

If the row appears successfully with nested table values, then it worked.


Q9. What are the data types used in sites? (Big tricky insert)
=>  Column	        Datatype
    site_id	         NUMBER
    address	        invoice_address_type
    state_ref	     REF state_type