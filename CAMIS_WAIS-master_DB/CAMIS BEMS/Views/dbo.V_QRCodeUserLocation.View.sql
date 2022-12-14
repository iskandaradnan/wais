USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_QRCodeUserLocation]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[V_QRCodeUserLocation]
AS
		SELECT		DISTINCT UserLocation.FacilityId,
					Block.BlockId,
					Block.BlockCode,
					Block.BlockName,
					Level.LevelId,
					Level.LevelCode,
					Level.LevelName,
					UserArea.UserAreaId,
					UserArea.UserAreaCode,
					UserArea.UserAreaName,
					UserArea.QRCode					AS	UserAreaQRCode,
					UserLocation.UserLocationId,
					UserLocation.UserLocationCode,
					UserLocation.UserLocationName,
					UserLocation.QRCode				AS	UserLocationQRCode,
					Block.ModifiedDateUTC
		FROM		MstLocationUserArea						AS	UserArea			WITH(NOLOCK)
					INNER JOIN	MstLocationUserLocation		AS	UserLocation		WITH(NOLOCK) ON	UserArea.UserAreaId			=	UserLocation.UserAreaId
					INNER JOIN	MstLocationLevel			AS	Level				WITH(NOLOCK) ON	UserArea.LevelId			=	Level.LevelId
					INNER JOIN	MstLocationBlock			AS	Block				WITH(NOLOCK) ON	UserArea.BlockId			=	Block.BlockId					
		WHERE		Block.Active =1 
					AND UserArea.Active =1 
					AND UserLocation.Active=1
GO
