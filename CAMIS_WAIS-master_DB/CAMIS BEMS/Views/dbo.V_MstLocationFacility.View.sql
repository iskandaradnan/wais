USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationFacility]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_MstLocationFacility]
AS
	SELECT	Facility.FacilityId,
			Customer.CustomerName,
			Facility.FacilityName,
			Facility.FacilityCode,
			Facility.Address,
			Facility.ActiveFrom,
			Facility.ActiveTo,
			Facility.ModifiedDateUTC
	FROM	MstLocationFacility Facility	WITH(NOLOCK)
			INNER JOIN MstCustomer Customer	WITH(NOLOCK)	ON Facility.CustomerId	=	Customer.CustomerId
	WHERE Facility.Active = 1
GO
