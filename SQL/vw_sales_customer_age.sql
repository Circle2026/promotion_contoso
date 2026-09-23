SELECT 
  t.OrderKey,
  t.CustomerKey,
  t.Age,
  CASE 
    WHEN t.Age >= 18 AND t.Age <= 24 THEN '18-24'
    WHEN t.Age >= 25 AND t.Age <= 34 THEN '25-34'
    WHEN t.Age >= 35 AND t.Age <= 44 THEN '35-44'
    WHEN t.Age >= 45 AND t.Age <= 54 THEN '45-54'
    WHEN t.Age >= 55 AND t.Age <= 64 THEN '55-64'
    ELSE '65+'
  END AS AgeGroup,
  t.ProductKey,
  t.Quantity,
  t.NetPrice,
  t.UnitPrice,
  t.UnitCost,
  t.DiscountRate,
  t.PromoFlag,
  t.Year,
  t.YearQuarter,
  t.Month
FROM (
  SELECT 
    s.OrderKey,
    CAST(s.CustomerKey AS STRING) AS CustomerKey,
    DATE_DIFF(CURRENT_DATE(), c.Birthday, YEAR) AS Age,
    s.ProductKey,
    s.Quantity,
    s.NetPrice,
    s.UnitPrice,
    s.UnitCost,
    s.DiscountRate,
    s.PromoFlag,
    s.Year,
    s.YearQuarter,
    s.Month
  FROM `circleproject-508903.contoso_clean.vw_sales_full` s
  JOIN `circleproject-508903.contoso_clean.customer_clean` c
    ON CAST(s.CustomerKey AS STRING) = c.CustomerKey
) t