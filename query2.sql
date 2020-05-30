/*2. Check, which store was the most profitable for company*/
SELECT
    store.store_name,
    COUNT(*) AS transactions,
    SUM(prod.price) AS total_sum,
    ROUND(SUM(prod.price) / COUNT(*),2) AS average_product_price
FROM sale.transaction tran
    INNER JOIN sale.point_of_sale AS pos ON tran.pos_id = pos.id
    INNER JOIN sale.store AS store ON pos.store_id = store.id
    INNER JOIN sale.product AS prod ON tran.product_id = prod.id
GROUP BY store.id,
         store.store_name
ORDER BY transactions DESC,
         total_sum DESC;