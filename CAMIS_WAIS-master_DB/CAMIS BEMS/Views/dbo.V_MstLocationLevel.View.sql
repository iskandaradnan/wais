USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationLevel]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_MstLocationLevel]
AS
SELECT		Level.LevelId,
			Facility.FacilityId,
			Facility.FacilityName,
			Block.BlockName,
			Level.LevelName,
			Level.ShortName,
			Level.LevelCode,
			Level.Active,
			Level.ModifiedDateUTC
	FROM	MstLocationLevel	AS	Level		WITH(NOLOCK)	
			INNER JOIN MstLocationBlock		AS	Block			WITH(NOLOCK)	ON	Level.BlockId		=	Block.BlockId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON	Level.FacilityId		=	Facility.FacilityId
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON	Level.CustomerId		=	Customer.CustomerId
GO
