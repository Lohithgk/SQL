/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       PP.[BusinessEntityID] -- pk, fk      
      ,[FirstName]
      ,[LastName]
	  ,[FirstName]+' '+[LastName] as [Name]
	  ,PH.[PhoneNumber]
	  ,EA.[EmailAddress]
	  ,EM.JobTitle
	  ,EM.MaritalStatus
	  ,EM.Gender	  

  FROM [AdWorks].[Person].[Person] as PP
  LEFT JOIN [AdWorks].[Person].[PersonPhone] as PH ON PH.BusinessEntityID = PP.BusinessEntityID
  LEFT JOIN [AdWorks].[Person].[EmailAddress] as EA ON EA.BusinessEntityID = PP.BusinessEntityID
  LEFT JOIN [AdWorks].[HumanResources].[Employee] as EM ON EM.BusinessEntityID = PP.BusinessEntityID
