USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_GetCauseCode]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[UspFM_GetCauseCode]                            
 
AS                                                
  
BEGIN TRY
 
  
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
   
  
 SELECT QualityCauseId as LovId,  
   CauseCode as FieldValue,  
   0 as IsDefault,
   [Description]     AS [Description] 
 FROM MstQAPQualityCause             
  
  
END TRY  
  
BEGIN CATCH  

 INSERT INTO ErrorLog(  
    Spname,  
    ErrorMessage,  
    createddate)  
 VALUES(  OBJECT_NAME(@@PROCID),  
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),  
    getdate()  
     )  
  
END CATCH
GO
