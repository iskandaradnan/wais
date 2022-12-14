USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngHeppmQuantitativeTasks]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <08/May/2018>
-- Description:	Description
-- =============================================
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Exec dbo.EngHeppmQuantitativeTasks 23,2

CREATE PROCEDURE [dbo].[uspFM_EngHeppmQuantitativeTasks]
@HeppmCheckListId int,@Version_No int

AS
BEGIN
	SET NOCOUNT ON;
SELECT 
 a.[Version] as versionNo
,qt.PPMCheckListQNId HeppmCheckListQNId      
,qt.QuantitativeTasks 
,qt.UOM
,qt.SetValues
,qt.LimitTolerance  
FROM EngAssetPPMCheckList m
LEFT JOIN EngAssetPPMCheckListQuantasksMstDet qt   on m.PPMCheckListId=qt.PPMCheckListId
left join EngPPMRegisterMst as n on n.PPMId=m.PPMCheckListId
left join EngPPMRegisterHistoryMst a on a.PPMId=n.PPMId
WHERE m.Active=1  AND qt.Active=1 AND m.ServiceId=2 and n.Active=1
AND m.PPMCheckListId=@HeppmCheckListId AND a.[Version]=@Version_No	
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
