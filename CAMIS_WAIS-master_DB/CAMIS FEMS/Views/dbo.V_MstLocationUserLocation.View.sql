USE [UetrackFemsdbPreProd]
GO
/****** Object:  View [dbo].[V_MstLocationUserLocation]    Script Date: 20-09-2021 16:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[V_MstLocationUserLocation]
as 
select a.UserLocationId,a.UserLocationCode, a.UserLocationName,
isnull(a.Active,1) as [StatusValue]
--,(case when a.Active=1 then 'Active'  else 'Inactive' end) [StatusValue]
,b.UserAreaCode,b.UserAreaName,C.BlockId
			,C.BlockName			,D.LevelId
			,D.LevelName		,a.ModifiedDateUTC,a.FacilityId
  from MstLocationUserLocation a
inner join MstLocationUserArea b on a.UserAreaId=b.UserAreaId
INNER JOIN MstLocationBlock C ON B.BlockId = C.BlockId
			INNER JOIN MstLocationLevel D ON B.LevelId = D.LevelId
GO
