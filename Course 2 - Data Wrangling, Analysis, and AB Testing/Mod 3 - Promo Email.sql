-- Pre-Exercise Window Function Review & Practice

-- Gathering, partitioning, and ranking order information.

SELECT
  user_id,
  invoice_id,
  paid_at,
  DENSE_RANK() OVER (PARTITION BY user_id ORDER BY paid_at ASC)
    AS dense_order_num
FROM 
  dsv1069.orders
GROUP BY
  user_id, invoice_id, paid_at
ORDER BY
  invoice_id
;

----------------------------------------------------------------------------------------










































