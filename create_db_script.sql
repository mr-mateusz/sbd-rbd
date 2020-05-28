
-- sales

CREATE DATABASE rdb;

\connect rdb;

CREATE SCHEMA sale;

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

--DROP DATABASE rdb;