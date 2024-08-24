SELECT 
GETDATE(),               -- 2024-08-24 02:07:40.287
EOMONTH(GETDATE()),      -- 2024-08-31 Last day for given day
EOMONTH(GETDATE(), 0),   -- 2024-08-31, add or substract month, default is 0 
EOMONTH(GETDATE(),-1),   -- 2024-07-31, substract 1 month 
EOMONTH('2024-01-30', 1) -- 2024-02-29, add 1 month
DATEADD(DD, 1, EOMONTH(GETDATE(), -1))  -- 2024-08-01 First day for the given day.

SELECT 
GETDATE(),
EOMONTH(GETDATE()),
DATEADD(DD, 1, EOMONTH(GETDATE(), -1)),
FORMAT(DATEADD(DD, 1, EOMONTH(GETDATE(), -1)), 'yyyyMMdd') -- 20240801 format date