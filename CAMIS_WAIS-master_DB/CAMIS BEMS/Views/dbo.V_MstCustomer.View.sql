USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstCustomer]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE VIEW [dbo].[V_MstCustomer]

AS

	SELECT	Customer.CustomerId,

			Customer.CustomerName,

	  	    Customer.CustomerCode,

			--Customer.ActiveFromDate,

			--Customer.ActiveToDate,

			Customer.ModifiedDateUTC,

			State,

			Country

	FROM	MstCustomer Customer	WITH(NOLOCK) 

--	WHERE Customer.Active = 1 
GO
