SELECT 
  s.OrderKey,
  s.ProductKey,
  s.Quantity,
  s.NetPrice,
  s.UnitPrice,
  s.UnitCost,
  s.CustomerKey,
  CAST(FORMAT_DATE('%Y%m%d', s.OrderDate) AS INT64) AS OrderDateKey,
  d.Date,
  d.DateKey,
  d.Year,
  d.YearQuarter,
  d.Quarter,
  d.Month,
  d.MonthShort,
  d.MonthNumber,
  d.DayofWeekShort,
  d.WorkingDay,

  -- 計算折扣率 (假設 NetPrice 是折扣後價格)
  SAFE_DIVIDE((s.UnitPrice - s.NetPrice), s.UnitPrice) AS DiscountRate,
  -- 促銷標記
  CASE 
    WHEN SAFE_DIVIDE((s.UnitPrice - s.NetPrice), s.UnitPrice) > 0 THEN 'Promotion'
    ELSE 'NonPromotion'
  END AS PromoFlag
FROM `circleproject-508903.contoso_clean.sales_clean` s
JOIN `circleproject-508903.contoso_clean.date_clean` d
  ON CAST(FORMAT_DATE('%Y%m%d', s.OrderDate) AS INT64) = d.DateKey