SELECT 
       SOD.[SalesOrderDetailID] -- PK
      ,SOD.[ProductID] -- FK
      ,PRC.Name
      ,PRO.ProductNumber
      ,PRO.Name
      ,PRO.Color
      ,PRO.Size
      ,PRO.Weight
      ,PRO.StandardCost
      ,PRM.ModifiedDate
      ,DATEPART(YYYY,PRM.ModifiedDate) AS [Modified_Year]
      
      ,SUM(SOD.[OrderQty])  as [Order Quantity]     
      ,SUM(SOD.[UnitPrice]) as [Unit Price]
      ,SUM(SOD.[LineTotal]) as [Total]      

  FROM [AdventureWorks].[SalesLT].[SalesOrderDetail] AS SOD
  LEFT JOIN [AdventureWorks].[SalesLT].[Product] AS PRO ON PRO.ProductID = SOD.ProductID
  LEFT JOIN [AdventureWorks].[SalesLT].[ProductCategory] AS PRC ON PRC.ProductCategoryID = PRO.ProductCategoryID
  LEFT JOIN [AdventureWorks].[SalesLT].[ProductModel] AS PRM ON PRM.ProductModelID = PRO.ProductModelID 
  
  GROUP BY 
       SOD.[SalesOrderDetailID] -- PK
      ,SOD.[ProductID] -- FK
      ,PRC.Name
      ,PRO.ProductNumber
      ,PRO.Name
      ,PRO.Color
      ,PRO.Size
      ,PRO.Weight
      ,PRO.StandardCost
      ,PRM.ModifiedDate