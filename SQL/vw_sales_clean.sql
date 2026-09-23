SELECT
  -- 原始訂單與相關 Key (保持明細顆粒度)
  OrderKey,
  LineNumber,
  OrderDate,
  DeliveryDate,
  CustomerKey,
  StoreKey,
  ProductKey,
  
  -- 原始幣別與數量單價
  CurrencyCode,
  ExchangeRate,
  Quantity,
  UnitPrice,
  NetPrice,
  UnitCost,
  
  DATE_DIFF(DeliveryDate, OrderDate, DAY) AS DeliveryDays, -- 交貨天數

  --  逐筆美金營收 (Revenue in USD)
  -- 注意：若 ExchangeRate 為原幣對美金匯率，請依資料定義選擇 * 或 /
  ROUND(Quantity * NetPrice / ExchangeRate, 2) AS Revenue_USD,

  --  逐筆美金成本 (Cost in USD)
  ROUND(Quantity * UnitCost / ExchangeRate, 2) AS Cost_USD,

  --  逐筆美金毛利 (Gross Profit in USD)
  ROUND((Quantity * NetPrice / ExchangeRate) - (Quantity * UnitCost / ExchangeRate), 2) AS GrossProfit_USD,

  -- 美金單價換算
  ROUND(UnitPrice / ExchangeRate, 2) AS UnitPrice_USD,
  ROUND(NetPrice / ExchangeRate, 2) AS NetPrice_USD,

  -- 美金財務金額指標
  ROUND(Quantity * UnitPrice / ExchangeRate, 2) AS GrossRevenue_USD,                             
  -- 原價總營收
  ROUND((UnitPrice - NetPrice) * Quantity / ExchangeRate, 2) AS TotalDiscount_USD,

  CASE 
    WHEN UnitPrice > 0 THEN ROUND((UnitPrice - NetPrice) / UnitPrice, 4)
    ELSE 0 
  END AS DiscountRate, -- 折扣率

  CASE 
    WHEN NetPrice > 0 THEN ROUND((NetPrice - UnitCost) / NetPrice, 4)
    ELSE 0 
  END AS GrossProfitMargin, -- 毛利率

  --  逐筆毛利率標籤/狀態 (便於 Power BI 做特徵篩選)
  CASE 
    WHEN (NetPrice - UnitCost) < 0 THEN '虧損 (Loss)'
    WHEN (NetPrice - UnitCost) = 0 THEN '平本 (Break-even)'
    ELSE '獲利 (Profitable)'
  END AS ProfitStatus

FROM
  `circleproject-508903`.contoso_clean.sales_clean