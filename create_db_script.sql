
-- sales

CREATE DATABASE sale;

CREATE TABLE sale.store_type (
    id              SERIAL          PRIMARY KEY,
    store_type_name VARCHAR(200)    NOT NULL,
    description     VARCHAR(400)
);

CREATE TABLE sale.unit (
    id              SERIAL          PRIMARY KEY,
    unit_name       VARCHAR(200)    NOT NULL,
    description     VARCHAR(400)
);

CREATE TABLE sale.currency (
    id              SERIAL          PRIMARY KEY,
    currency_name   VARCHAR(200)    NOT NULL,
    currency_code   VARCHAR(25)     NOT NULL
);

CREATE TABLE sale.transaction_type (
    id                  SERIAL          PRIMARY KEY,
    transaction_type    VARCHAR(200)    NOT NULL,
    description         VARCHAR(400)
);

CREATE TABLE sale.market (
    id              SERIAL          PRIMARY KEY,
    market_name     VARCHAR(400)    NOT NULL,
    market_mnemo    VARCHAR(400)
);

CREATE TABLE sale.store (
    id              SERIAL          PRIMARY KEY,
    store_name      VARCHAR(400)    NOT NULL,
    street_name     VARCHAR(400)    NOT NULL,
    street_number   VARCHAR(100)    NOT NULL,
    local_number    VARCHAR(100)    NOT NULL,
    postal_code     VARCHAR(6)      NOT NULL,
    market_id       INT             NOT NULL,
    store_type_id   INT             NOT NULL
);

ALTER TABLE sale.store ADD CONSTRAINT fk_market_store_market_id FOREIGN KEY (market_id)
    REFERENCES sale.market (id) ON DELETE RESTRICT;

ALTER TABLE sale.store ADD CONSTRAINT fk_store_type_store_store_type_id FOREIGN KEY (store_type_id)
    REFERENCES sale.store_type (id) ON DELETE RESTRICT;

CREATE TABLE sale.product (
    id                      SERIAL          PRIMARY KEY,
    product_name            VARCHAR(200)    NOT NULL,
    product_business_code   VARCHAR(200),
    begin_date              DATE            NOT NULL,
    end_date                DATE,
    price                   INT             NOT NULL,
    quantity                INT             NOT NULL,
    legacy_id               INT,
    market_id               INT             NOT NULL,
    unit_id                 INT             NOT NULL,
    currency_id             INT             NOT NULL
);

ALTER TABLE sale.product ADD CONSTRAINT fk_product_product_legacy_id FOREIGN KEY (legacy_id)
    REFERENCES sale.product (id) ON DELETE RESTRICT;

ALTER TABLE sale.product ADD CONSTRAINT fk_market_product_market_id FOREIGN KEY (market_id)
    REFERENCES sale.market (id) ON DELETE RESTRICT;

ALTER TABLE sale.product ADD CONSTRAINT fk_unit_product_unit_id FOREIGN KEY (unit_id)
    REFERENCES sale.unit (id) ON DELETE RESTRICT;

ALTER TABLE sale.product ADD CONSTRAINT fk_currency_product_currency_id FOREIGN KEY (currency_id)
    REFERENCES sale.currency (id) ON DELETE RESTRICT;

CREATE TABLE sale.point_of_sale (
    id          SERIAL PRIMARY KEY,
    pos_code    VARCHAR(400),
    store_id    INT
);

ALTER TABLE sale.point_of_sale ADD CONSTRAINT fk_store_point_of_sale_store_id FOREIGN KEY (store_id)
    REFERENCES sale.store (id) ON DELETE RESTRICT;

CREATE TABLE sale.transaction (
    pos_id              INT     NOT NULL,
    transaction_type_id INT     NOT NULL,
    product_id          INT     NOT NULL,
    transaction_date    DATE    NOT NULL
);

ALTER TABLE sale.transaction ADD CONSTRAINT fk_point_of_sale_transaction_pos_id FOREIGN KEY (pos_id)
    REFERENCES sale.point_of_sale (id) ON DELETE RESTRICT;

ALTER TABLE sale.transaction ADD CONSTRAINT fk_transaction_type_transaction_transaction_type_id FOREIGN KEY (transaction_type_id)
    REFERENCES sale.transaction_type (id) ON DELETE RESTRICT;

ALTER TABLE sale.transaction ADD CONSTRAINT fk_product_transaction_product_id FOREIGN KEY (product_id)
    REFERENCES sale.product (id) ON DELETE RESTRICT;



INSERT INTO sale.store_type 
(
    store_type,
    descrition
)
VALUES
("Supermarket","Store area > 500 square meters."),
("Market hall","Store area > 1500 square meters. Distributed suppliers"),
("Gass station","To be defined"),
("Glossary","Local or sublocal glossary shop"),
("Shopping Gallery","Store area <= 500");

INSERT INTO sale.market
(
    market_name 
    market_mnemo
)
VALUES
("Western Europe","WST_EU"),
("Eastern Europe","EST_EU"),
("North America","NTH_AMER"),
("South America","STH_AMER"),
("Central Asia","CNTL_ASIA"),
("Pacific and Oceanic","PAC_N_OCEAN"),
("India Subcontinent","IND_SUB");

INSERT INTO sale.store
(
    store_name,   
    street_name,  
    street_number,
    local_number, 
    postal_code,  
    market_id,    
    store_type_id
)
VALUES
("Tesco","Hemingway st.","12","5K","01-954",1,1),
("Auchan","E. M. Remarque st.","170A","1","55-439",1,2),
("Shell Station","Puszkin st.","3","14","44-901",2,3),
("Kauffmann","Gagarin st.","11","18S","89-674",2,4),
("Netto","Neil Armstrong av.","1","5","01-005",3,5),
("Pepco","Simone Boulivare st.","13","332","05-092",4,1),
("Carefour","Chang Kai Shek st.","7","1233","09-466",5,2),
("Lidl","Darwin av.","1","94","02-112",6,4),
("Super Mercado","Brama Puta st.","40","1301","06-750",7,5);

INSERT INTO sale.unit
(
    unit_type,
    description
)
VALUES
("L","Litr"),
("g","Gram"),
("mL","Mililitr"),
("gal","Gallon"),
("lb","Pound"),
("kg","Kilogram");

INSERT INTO sale.currency
(
    currency_name,
    currency_code
)
VALUES
("Złoty","PLN"),
("United States Dollar","USD"),
("Australian Dollar ","AUD"),
("British Pound","GBP"),
("Euro","EUR"),
("Japanese Yen","JPY"),
("Swiss Frank","CHF");

INSERT INTO sale.transaction_type
(
    transaction_type,
    description
)
VALUES
("Cash","Paid by cash in local currency"),
("BLIK","Paid by phone"),
("Credit Card","Paid by bank transfer"),
("Invoice","Invoice for company"),
("Debit Card","Debt was made");

INSERT INTO sale.product
(
    product_name,         
    product_business_code,
    begin_date,           
    end_date,             
    price,                
    quantity,             
    legacy_id,            
    market_id,            
    unit_id,              
    currency_id          
)
VALUES
("Coca Cola Light Can","CCL 001","1999-01-01","9999-12-31",1.99,1,NULL,1,3,1),
("Coca Cola Zero Can","CCZ 001","2005-06-01","9999-12-31",2.99,1,NULL,2,4,2),
("Fanta Orange 4pack","FO4P","2000-02-01","9999-12-31",12.99,4,NULL,3,5,3),
("Sprite Can","S 020","2001-01-01","9999-12-31",0.99,1,NULL,4,1,5),
("Lay's Paprica","LAY PAP","2001-01-01","9999-12-31",0.49,1,NULL,6,6,7),
("Lay's Onion","LAY ON","2010-01-01","9999-12-31",2.49,1,NULL,7,2,6),
("Lay's Salt","LAY SLT","1970-01-01","1990-12-31",4.99,1,NULL,3,5,4),
("Lay's Super Salty","LAY SPR SLT","1991-01-01","9999-12-31",6.99,1,7,3,5,4),
("L&M Red Toasted","LM RT","1950-01-01","1974-12-31",16.99,2,NULL,1,5,2),
("L&M Red Browned","LM RB","1975-01-01","9999-12-31",21.99,2,10,1,5,2),
("L&M Blue","LM B","1980-01-01","9999-12-31",17.99,2,NULL,5,5,5);


--DROP DATABASE sale;


