USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionMstDedIndicatorFormula_GetId]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


            
CREATE PROCEDURE [dbo].[DeductionMstDedIndicatorFormula_GetId]                  
                 
                   
AS                   
    -- Exec [DeductionMstDedIndicatorFormula_GetId]               
                
--/*=====================================================================================================================                
--APPLICATION  : UETrack                
--NAME    : MstDedIndicatorFormula_GetId               
--DESCRIPTION  : GETS THE MstDedIndicatorFormula DETAILS                
--AUTHORS   : SIDDHANT                
--DATE    : 8-JAN-2020                
-------------------------------------------------------------------------------------------------------------------------                
--VERSION HISTORY                 
--------------------:---------------:---------------------------------------------------------------------------------------                
--Init    : Date          : Details                
--------------------:---------------:---------------------------------------------------------------------------------------                
--AIDA NAZRI           : 3-MAR-2020 :                 
-------:------------:----------------------------------------------------------------------------------------------------*/                
                
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                   
SELECT        dbo.MstDedIndicatorDet.ServiceId, dbo.MstDedIndicatorDet.IndicatorNo, dbo.MstDedIndicatorDet.IndicatorName, dbo.MstDedIndicatorDet.PerformanceIndicator, dbo.FMLovMst.FieldValue AS Frequency,       
                         dbo.MstDedIndicatorFormula.AssetStartPrice, dbo.MstDedIndicatorFormula.AssetEndPrice, dbo.MstDedIndicatorFormula.DeductionFigure, dbo.MstDedIndicatorDet.Active      
FROM            dbo.MstDedIndicatorDet INNER JOIN      
                         dbo.FMLovMst ON dbo.MstDedIndicatorDet.Frequency = dbo.FMLovMst.LovId INNER JOIN      
                         dbo.MstDedIndicatorFormula ON dbo.MstDedIndicatorDet.IndicatorDetId = dbo.MstDedIndicatorFormula.IndicatorDetId      
WHERE        (dbo.MstDedIndicatorDet.Active = 'True')         
AND ServiceId=1                
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END
GO
