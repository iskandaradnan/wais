USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationUserArea]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[V_MstLocationUserArea]
as
SELECT		 UserAreaId
            ,UserAreaCode
            ,UserAreaName
			,B.BlockId
			,B.BlockName
			,C.LevelId
			,C.LevelName
			,(case when A.Active=1 then 'Active'  else 'Inactive' end) [StatusValue]
			,A.Active 
			,A.ModifiedDateUTC
			,A.FacilityId
			FROM MstLocationUserArea A INNER JOIN MstLocationBlock B ON A.BlockId = B.BlockId
			INNER JOIN MstLocationLevel C ON A.LevelId = C.LevelId
GO
