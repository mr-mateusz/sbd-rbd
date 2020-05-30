/*3. Normalize product price to USD*/
SELECT
    prod.product_name,
    prod.product_business_code,
    CASE curr.currency_code
      WHEN 'PLN' THEN ROUND(prod.price * 0.25,2)
      WHEN 'USD' THEN prod.price
      WHEN 'AUD' THEN ROUND(prod.price * 0.65,2)
      WHEN 'EUR' THEN ROUND(prod.price * 1.24,2)
      WHEN 'CHF' THEN ROUND(prod.price * 1.05,2)
      WHEN 'JPY' THEN ROUND(prod.price * 0.14,2)
      WHEN 'GBP' THEN ROUND(prod.price * 1.12,2)
      ELSE 0.0
    END price_in_USD,
    CONCAT(CAST(prod.price AS VARCHAR),' ',curr.currency_code) AS original_price
FROM sale.product prod
INNER JOIN sale.currency curr ON prod.currency_id = curr.id;