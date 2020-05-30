/*1. Find, which product has better sale factor (in term for number of sales product) - new or old (legacy product)?*/
WITH legacy AS
(
    SELECT
        legacy.id,
        legacy.product_name AS product_name,
        COUNT(*) AS sale_products
    FROM sale.product current
        INNER JOIN sale.product legacy ON current.legacy_id = legacy.id
        INNER JOIN sale.transaction tran ON legacy.id = tran.product_id
    GROUP BY legacy.id, legacy.product_name
),
current AS
(
    SELECT
        id,
        product_name,
        COUNT(*) AS sale_products,
        legacy_id
    FROM sale.product current
        INNER JOIN sale.transaction tran ON current.id = tran.product_id
    WHERE end_date = '9999-12-31'
    GROUP BY id
)
SELECT
    legacy.product_name AS legacy_product,
    legacy.sale_products AS legacy_sale,
    current.product_name AS current_product,
    current.sale_products AS current_sale,
    CASE
        WHEN legacy.sale_products > current.sale_products THEN 'Legacy product sale is better!'
        WHEN legacy.sale_products < current.sale_products THEN 'Current product sale is better!'
    ELSE
        'Sale is equal!'
    END AS sale_compare
FROM legacy
INNER JOIN current ON legacy.id = current.legacy_id;