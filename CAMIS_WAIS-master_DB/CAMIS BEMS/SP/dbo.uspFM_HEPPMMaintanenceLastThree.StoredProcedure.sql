USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_HEPPMMaintanenceLastThree]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <08/May/2018>
-- Description:	Screen fetch
-- =============================================

CREATE PROCEDURE [dbo].[uspFM_HEPPMMaintanenceLastThree]

@HeppmCheckListId   int,
@Version_No			int

AS
BEGIN
SET NOCOUNT ON;

SELECT  
 PPMCheckListQTId HeppmCheckListMTId
,PPMCheckListId HeppmCheckListId
,QualitativeTasks as LastThreeMaintTasks 
,RowId

from
(
SELECT ROW_NUMBER() OVER (ORDER BY PPMCheckListQTId ASC) AS RowId,e.*
FROM EngAssetPPMCheckListMaintTasksMstDet  e
JOIN EngAssetPPMCheckList m on e.PPMCheckListId=m.PPMCheckListId 
inner join EngPPMRegisterHistoryMst a on m.PPMCheckListId=a.PPMId
WHERE m.ServiceId=2 AND m.PPMCheckListId=@HeppmCheckListId  AND a.[Version]= @Version_No AND m.Active=1 AND e.Active=1 and a.Active=1 )as a
where a.RowId between 4 and 6
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
