USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstCustomer_Export]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [dbo].[V_MstCustomer_Export]

AS



	SELECT	Customer.CustomerId,

			Customer.CustomerCode,

			Customer.CustomerName,

			Customer.[Address],

			Customer.Address2,

			Customer.PostCode,

			Customer.State,

			Customer.Country,

			Customer.Latitude,

			Customer.Longitude,

			Customer.ContactNo         As PhoneNumber,

			Customer.FaxNo             As FaxNumber,

		    Customer.Remarks,

			--FORMAT(Customer.ActiveFromDate,'dd-MMM-yyyy')	AS	ActiveFromDate,

			--FORMAT(Customer.ActiveToDate,'dd-MMM-yyyy')		AS	ActiveToDate,

			Customer.ContractPeriodInYears,

			

			CustomerContactInfo.Name,

			CustomerContactInfo.Designation,

			CustomerContactInfo.ContactNo,

			CustomerContactInfo.Email,

			CASE WHEN Customer.Active=1 THEN 'Active'

				 WHEN Customer.Active=0 THEN 'Inactive'

			END									AS	StatusValue,

			Customer.ModifiedDateUTC

	FROM	MstCustomer AS	Customer	WITH(NOLOCK)	
	left JOIN MstCustomerContactInfo  AS  CustomerContactInfo  WITH(NOLOCK) ON Customer.CustomerId = CustomerContactInfo.CustomerId
	--WHERE Customer.Active = 1 
GO
