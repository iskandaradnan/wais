USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_PeriodicWorkRecordSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_CLS_PeriodicWorkRecordSave] 0, 25, 25, '345345fgd' , 10714, 10719        
-- select * from CLS_PeriodicWorkRecord        
CREATE PROC [dbo].[Sp_CLS_PeriodicWorkRecordSave]        
       
@pPeriodicId int,        
@pCustomerId int,        
@pFacilityId int,        
@pDocumentNo varchar(30)='',        
@pYear int,        
@pMonth varchar(30)        
     
AS        
BEGIN        
SET NOCOUNT ON;        
        
BEGIN TRY     
    
 IF(@pPeriodicId = 0)    
 BEGIN        
   IF(EXISTS(SELECT 1 FROM CLS_PeriodicWorkRecord WHERE CustomerId = @pCustomerId and FacilityId = @pFacilityId and  [Year] = @pYear AND [Month] = @pMonth ))        
 BEGIN     
  SELECT -1 as PeriodicId,          
  (SELECT top 1 FieldValue FROM FMLovMst where LovId = @pYear) as [Year],        
  (SELECT top 1 FieldValue FROM FMLovMst where LovId = @pMonth) as [Month],      
  (SELECT top 1 DocumentNo FROM CLS_PeriodicWorkRecord WHERE CustomerId = @pCustomerId and FacilityId = @pFacilityId        
  AND [Year] = @pYear AND [Month] = @pMonth ) AS [DocumentNo]        
   END        
   ELSE IF(EXISTS(SELECT 1 FROM CLS_PeriodicWorkRecord WHERE DocumentNo = @pDocumentNo))      
    BEGIN              
  SELECT -2 as PeriodicId, @pDocumentNo AS DocumentNo       
    END        
   ELSE      
   BEGIN      
   INSERT INTO CLS_PeriodicWorkRecord values(@pCustomerId,@pFacilityId,@pDocumentNo,@pYear,@pMonth)        
   SELECT MAX(PeriodicId) as PeriodicId FROM CLS_PeriodicWorkRecord        
   END      
 END    
 ELSE    
 BEGIN    
  SELECT @pPeriodicId  as PeriodicId  
 END    
    
END TRY        
BEGIN CATCH       
     
 INSERT INTO ExceptionLog (          
 ErrorLine, ErrorMessage, ErrorNumber,          
 ErrorProcedure, ErrorSeverity, ErrorState,          
 DateErrorRaised          
 )          
 SELECT          
 ERROR_LINE () as ErrorLine,          
 Error_Message() as ErrorMessage,          
 Error_Number() as ErrorNumber,          
 Error_Procedure() as 'Sp_CLS_PeriodicWorkRecordFields',          
 Error_Severity() as ErrorSeverity,          
 Error_State() as ErrorState,          
 GETDATE () as DateErrorRaised          
        
END CATCH        
END
GO
