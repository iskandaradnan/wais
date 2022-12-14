USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionKPIReportsandRecordMst_GetId]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
CREATE PROCEDURE [dbo].[DeductionKPIReportsandRecordMst_GetId]        
                     
                       
AS                       
    -- Exec [DeductionKPIReportsandRecordMst_GetId]                   
                    
--/*=====================================================================================================================                    
--APPLICATION  : UETrack                    
--NAME    : DeductionKPIReportsandRecordMst_GetId                   
--DESCRIPTION  : GETS THE KPIReportsandRecordMst DETAILS                    
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
                       
SELECT        dbo.KPIReportsandRecordMst.ServiceId, dbo.KPIReportsandRecordMst.ReportType, dbo.KPIReportsandRecordMst.SubmissionDate, dbo.KPIReportsandRecordMst.Remarks, dbo.KPIReportsandRecordMst.PIC,         
                         [uetrackMasterdbPreProd].[DBO].FMLovMst.FieldValue AS Frequency, dbo.KPIReportsandRecordMst.CustomerReportId, dbo.KPIReportsandRecordMst.Frequency AS FrequencyId        
FROM            dbo.KPIReportsandRecordMst INNER JOIN        
                         [uetrackMasterdbPreProd].[DBO].FMLovMst ON dbo.KPIReportsandRecordMst.Frequency = [uetrackMasterdbPreProd].[DBO].FMLovMst.LovId   
						 WHERE dbo.KPIReportsandRecordMst.Active = 'True'
END TRY                      
BEGIN CATCH                      
                      
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                      
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                      
                      
THROW                      
                      
END CATCH                      
SET NOCOUNT OFF                      
END
GO
