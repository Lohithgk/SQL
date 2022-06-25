SELECT 
       SOD.[SalesOrderDetailID] -- PK
      ,SOD.[ProductID] -- FK
      ,PRO.ProductID -- PK
      ,PRO.ProductNumber
      ,PRO.Name
      ,PRO.StandardCost
      ,PRO.ListPrice
      ,SUM(SOD.[OrderQty])  as [Order Quantity]     
      ,SUM(SOD.[UnitPrice]) as [Unit Price]
      ,SUM(SOD.[LineTotal]) as [Total]
      

  FROM [AdventureWorks].[SalesLT].[SalesOrderDetail] AS SOD
  LEFT JOIN [AdventureWorks].[SalesLT].[Product] AS PRO ON PRO.ProductID = SOD.ProductID
  GROUP BY 
       SOD.[SalesOrderDetailID] -- PK
      ,SOD.[ProductID] -- FK
      ,PRO.ProductID -- PK
      ,PRO.ProductNumber
      ,PRO.Name
      ,PRO.StandardCost
      ,PRO.ListPrice