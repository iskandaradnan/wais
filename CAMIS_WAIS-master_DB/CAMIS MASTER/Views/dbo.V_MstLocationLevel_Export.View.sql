USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationLevel_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_MstLocationLevel_Export]
AS
	SELECT	Level.LevelId,
			Level.CustomerId,
			Customer.CustomerName,
			Level.FacilityId,
			Facility.FacilityName,
			Block.BlockName,
            Level.LevelCode,
            Level.LevelName,
			Level.ShortName,
			FORMAT(Block.ActiveFromDate,'dd-MMM-yyyy')	AS	ActiveFromDate,
			FORMAT(Block.ActiveToDate,'dd-MMM-yyyy')	AS	ActiveToDate,
			CASE WHEN Level.Active=1 THEN 'Active'
				 WHEN Level.Active=0 THEN 'Inactive'
			END									AS	[Status],
			Level.Active,
			Level.ModifiedDateUTC
	FROM	MstLocationLevel	AS	Level		WITH(NOLOCK)
			INNER JOIN MstLocationBlock		AS	Block			WITH(NOLOCK)	ON	Level.BlockId			=	Block.BlockId
			INNER JOIN MstLocationFacility	AS	Facility		WITH(NOLOCK)	ON	Level.FacilityId		=	Facility.FacilityId
			INNER JOIN MstCustomer			AS	Customer		WITH(NOLOCK)	ON	Level.CustomerId		=	Customer.CustomerId
GO
