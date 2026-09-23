SELECT p1.ProductName AS ProductA,
       p2.ProductName AS ProductB,
       p1.CategoryName AS CategoryA,
       p2.CategoryName AS CategoryB,
       COUNT(*) AS PairCount
FROM `circleproject-508903`.contoso_clean.sales_clean s1
JOIN `circleproject-508903`.contoso_clean.sales_clean s2 
  ON s1.OrderKey = s2.OrderKey
 AND s1.ProductKey < s2.ProductKey
JOIN `circleproject-508903`.contoso_clean.product_clean p1 ON s1.ProductKey = p1.ProductKey
JOIN `circleproject-508903`.contoso_clean.product_clean p2 ON s2.ProductKey = p2.ProductKey
GROUP BY ProductA, ProductB, CategoryA, CategoryB
ORDER BY PairCount DESC