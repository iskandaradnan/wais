USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationBlock]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[V_MstLocationBlock]
AS
SELECT		BlockId,
			Facility.FacilityId,
			Facility.FacilityName,
			Block.BlockName,
			Block.ShortName,
			Block.BlockCode,
			Block.Active,
			Block.ModifiedDateUTC
	FROM	MstLocationBlock				AS	Block		WITH(NOLOCK)
			INNER JOIN MstLocationFacility	AS	Facility	WITH(NOLOCK)	ON	Block.FacilityId	=	Facility.FacilityId
			INNER JOIN MstCustomer			AS	Customer	WITH(NOLOCK)	ON	Block.CustomerId	=	Customer.CustomerId
	WHERE 1 = 1
GO
