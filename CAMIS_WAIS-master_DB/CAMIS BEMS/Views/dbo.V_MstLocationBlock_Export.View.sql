USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationBlock_Export]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_MstLocationBlock_Export]
AS
SELECT		Customer.CustomerName,
			Facility.FacilityName,
			Facility.FacilityId,
			Block.BlockName,
			Block.ShortName,
			Block.BlockCode,
			CAST(Block.ActiveFromDate AS DATE)	AS	ActiveFromDate,
			CAST(Block.ActiveToDate AS DATE)	AS	ActiveToDate,
			CASE WHEN Block.Active=1 THEN 'Active'
				 WHEN Block.Active=0 THEN 'Inactive'
			END								AS		[Status],
			Block.Active,
			Block.ModifiedDateUTC
	FROM	MstLocationBlock				AS	Block		WITH(NOLOCK)
			INNER JOIN MstLocationFacility	AS	Facility	WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
			INNER JOIN MstCustomer			AS	Customer	WITH(NOLOCK)	ON	Block.CustomerId	=	Customer.CustomerId
	WHERE 1 = 1
GO
