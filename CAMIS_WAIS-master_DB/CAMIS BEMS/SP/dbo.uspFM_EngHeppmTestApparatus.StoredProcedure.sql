USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngHeppmTestApparatus]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		<Aravinda Raja>
-- Create date: <08/May/2018>
-- Description:	Test Apparatus Report
-- =============================================
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[uspFM_EngHeppmTestApparatus]

@HeppmCheckListId int,
@Version_No int

AS
BEGIN
SET NOCOUNT ON;

SELECT 
m.PPMCheckListId as HeppmCheckListId,
ta.Description as TestApparatusDec  
FROM EngAssetPPMCheckList m
LEFT JOIN EngAssetPPMCheckListTestAppMstDet ta   on m.PPMCheckListId=ta.PPMCheckListId
left join EngPPMRegisterHistoryMst a on m.PPMCheckListId=a.PPMId
WHERE m.Active=1 AND ta.Active=1  AND m.ServiceId=2 
AND m.PPMCheckListId=@HeppmCheckListId AND a.Version=@Version_No
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
GO
