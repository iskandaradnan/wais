USE [UetrackBemsdbPreProd]
GO
/****** Object:  View [dbo].[V_QRCodeUserArea]    Script Date: 20-09-2021 17:03:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[V_QRCodeUserArea]
AS
		SELECT		DISTINCT UserArea.FacilityId,
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
					Block.ModifiedDateUTC
		FROM		MstLocationUserArea						AS	UserArea			WITH(NOLOCK)
					INNER JOIN	MstLocationLevel			AS	Level				WITH(NOLOCK) ON	UserArea.LevelId			=	Level.LevelId
					INNER JOIN	MstLocationBlock			AS	Block				WITH(NOLOCK) ON	UserArea.BlockId			=	Block.BlockId					
		WHERE		Block.Active =1 
					AND UserArea.Active =1
GO
