-- Price, Volume, Mix Analysis for All Clients --
USE TempDB
GO
---------------------------------------------------------------------------------------------------
-- Drop the table 'tbl_Sales_Impact' in schema 'dbo', if it exists
IF EXISTS (
    SELECT *
    FROM sys.tables
    JOIN sys.schemas ON sys.tables.schema_id = sys.schemas.schema_id
    WHERE sys.schemas.name = N'dbo' AND sys.tables.name = N'tbl_Sales_Impact')

DROP TABLE dbo.tbl_Sales_Impact
GO
---------------------------------------------------------------------------------------------------
-- Declaring Variables --
DECLARE @PrevYearMaxDate AS INT = (SELECT Prev_Max_Date FROM [TempDB].[dbo].[Derived_Variables])
DECLARE @CurrYear AS INT = (SELECT Fiscal_Year FROM [TempDB].[dbo].[Derived_Variables])
DECLARE @PrevYear AS INT = @CurrYear - 1
---------------------------------------------------------------------------------------------------
-- Price, Volume, Mix Analysis for All Clients --
;WITH CurrYearData AS 
(
    SELECT 
        S.[Client_ID],
        CONCAT(S.[Category_Code], '-', S.[Category_Desc]) AS [Category],
        S.[Product_Code],
        S.[Fiscal_Year],
        S.[Fiscal_Month],
        SUM(S.[Sales_Amount]) AS Curr_Sales_Amount,
        SUM(S.[Sales_Quantity]) AS Curr_Sales_Quantity,
        SUM(CASE WHEN S.[Record_Type] = 'Misc' THEN S.[Sales_Amount] ELSE 0 END) AS Curr_Misc_Sales
    FROM [TempDB].[dbo].[Sales_Data] S
    WHERE ISNULL(S.[Category_ID], 0) NOT IN (17, 18) AND S.[Fiscal_Year] = @CurrYear
    GROUP BY S.[Client_ID], S.[Category_Code], S.[Category_Desc], S.[Product_Code], S.[Fiscal_Month], S.[Fiscal_Year]
)
---------------------------------------------------------------------------------------------------
, PrevYearData AS 
(
    SELECT 
        S.[Client_ID],
        CONCAT(S.[Category_Code], '-', S.[Category_Desc]) AS [Category],
        S.[Product_Code],
        S.[Fiscal_Year],
        S.[Fiscal_Month],
        SUM(S.[Sales_Amount]) AS Prev_Sales_Amount,
        SUM(S.[Sales_Quantity]) AS Prev_Sales_Quantity,
        SUM(CASE WHEN S.[Record_Type] = 'Misc' THEN S.[Sales_Amount] ELSE 0 END) AS Prev_Misc_Sales
    FROM [TempDB].[dbo].[Sales_Data] S
    WHERE ISNULL(S.[Category_ID], 0) NOT IN (17, 18) AND S.[Fiscal_Year] = @PrevYear AND S.[Date_Key] <= @PrevYearMaxDate
    GROUP BY S.[Client_ID], S.[Category_Code], S.[Category_Desc], S.[Product_Code], S.[Fiscal_Month], S.[Fiscal_Year]
)
---------------------------------------------------------------------------------------------------
, ClientProductMetrics AS (
    SELECT 
        ISNULL(CY.[Client_ID], PY.[Client_ID]) AS [Client_ID],
        ISNULL(CY.[Product_Code], PY.[Product_Code]) AS [Product_Code],
        ISNULL(CY.[Category], PY.[Category]) AS [Category],
        ISNULL(CY.[Fiscal_Month], PY.[Fiscal_Month]) AS [Month],
        CY.[Curr_Sales_Amount], CY.[Curr_Sales_Quantity], CY.[Curr_Misc_Sales],
        PY.[Prev_Sales_Amount], PY.[Prev_Sales_Quantity], PY.[Prev_Misc_Sales],
        ISNULL(CY.[Curr_Sales_Amount], 0) - ISNULL(PY.[Prev_Sales_Amount], 0) AS [YoY_Sales],
        CASE WHEN CY.[Curr_Sales_Amount] != 0 AND PY.[Prev_Sales_Amount] != 0 
             THEN (CY.[Curr_Sales_Amount]/NULLIF(CY.[Curr_Sales_Quantity], 0) - PY.[Prev_Sales_Amount]/NULLIF(PY.[Prev_Sales_Quantity], 0)) * PY.[Prev_Sales_Quantity] 
             ELSE 0 END AS Price_Impact,
        CASE WHEN CY.[Curr_Sales_Quantity] != 0 AND PY.[Prev_Sales_Quantity] != 0 
             THEN (CY.[Curr_Sales_Quantity] - PY.[Prev_Sales_Quantity]) * (PY.[Prev_Sales_Amount]/NULLIF(PY.[Prev_Sales_Quantity], 0)) 
             ELSE 0 END AS Volume_Impact,
        CASE WHEN CY.[Curr_Sales_Quantity] != 0 AND PY.[Prev_Sales_Quantity] != 0 AND CY.[Curr_Sales_Amount] != 0 AND PY.[Prev_Sales_Amount] != 0 
             THEN (CY.[Curr_Sales_Quantity] - PY.[Prev_Sales_Quantity]) * (CY.[Curr_Sales_Amount]/NULLIF(CY.[Curr_Sales_Quantity], 0) - PY.[Prev_Sales_Amount]/NULLIF(PY.[Prev_Sales_Quantity], 0)) 
             ELSE 0 END AS Mix_Impact,
        CASE WHEN PY.[Prev_Sales_Amount] IS NULL THEN CY.[Curr_Sales_Amount] ELSE 0 END AS [New_Product_Sales],
        CASE WHEN CY.[Curr_Sales_Amount] IS NULL THEN PY.[Prev_Sales_Amount] ELSE 0 END AS [Discontinued_Product_Sales]
    FROM CurrYearData AS CY
    FULL OUTER JOIN PrevYearData AS PY 
        ON CY.[Product_Code] = PY.[Product_Code] AND CY.[Fiscal_Month] = PY.[Fiscal_Month] AND CY.[Client_ID] = PY.[Client_ID]
)
---------------------------------------------------------------------------------------------------
SELECT 
    CPM.[Client_ID],
    CL.[Client_Name],
    CL.[Parent_Client_ID],
    CL.[Parent_Client_Name],
    CL.[Sales_Region],
    CL.[Region_Name],
    CL.[Manager_ID],
    CL.[Manager_Name],
    CPM.[Category],
    CPM.[Month],
    SUM(CPM.[Curr_Sales_Amount]) AS [Curr_Sales_Amount],
    SUM(CPM.[Curr_Sales_Quantity]) AS [Curr_Sales_Quantity],
    SUM(CPM.[Curr_Misc_Sales]) AS [Curr_Misc_Sales],
    SUM(CPM.[Prev_Sales_Amount]) AS [Prev_Sales_Amount],
    SUM(CPM.[Prev_Sales_Quantity]) AS [Prev_Sales_Quantity],
    SUM(CPM.[Prev_Misc_Sales]) AS [Prev_Misc_Sales],
    SUM(CPM.[YoY_Sales]) AS [YoY_Sales],
    SUM(CPM.[Price_Impact]) AS [Price_Impact],
    SUM(CPM.[Volume_Impact]) AS [Volume_Impact],
    SUM(CPM.[Mix_Impact]) AS [Mix_Impact],
    SUM(CPM.[New_Product_Sales]) AS [New_Product_Sales],
    SUM(CPM.[Discontinued_Product_Sales] * -1) AS [Discontinued_Product_Sales]
INTO dbo.tbl_Sales_Impact
FROM ClientProductMetrics AS CPM
LEFT JOIN [TempDB].[dbo].[Client_Master] AS CL ON CL.[Client_ID] = CPM.[Client_ID]
GROUP BY CPM.[Client_ID], CL.[Client_Name], CL.[Parent_Client_ID], CL.[Parent_Client_Name], CL.[Sales_Region], CL.[Region_Name], CL.[Manager_ID], CL.[Manager_Name], CPM.[Month], CPM.[Category]
