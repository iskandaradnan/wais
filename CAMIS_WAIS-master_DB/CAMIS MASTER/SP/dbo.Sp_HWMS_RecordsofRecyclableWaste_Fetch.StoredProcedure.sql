USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Fetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Fetch] 0, '12/1/2020 12:00:00 AM', '12/31/2020 12:00:00 PM'
CREATE PROC [dbo].[Sp_HWMS_RecordsofRecyclableWaste_Fetch]   
@RecyclableId INT,  
 @StartDate DATETIME,  
 @EndDate DATETIME  
   
AS   
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
IF(EXISTS(select 1 from HWMS_RecordsofRecyclableWaste_CSWRSDetails where  RecyclableId = @RecyclableId))  
 BEGIN  
   
 SELECT * FROM HWMS_RecordsofRecyclableWaste_CSWRSDetails where  RecyclableId = @RecyclableId  AND [isDeleted]=0  
 END  
 ELSE  
 BEGIN    
  SELECT A.* FROM HWMS_CSWRecordSheet A  
  LEFT JOIN FMLovMst B ON A.Status = B.LovId   
  WHERE B.FieldValue = 'Open' and a.CreatedDate BETWEEN @StartDate AND @EndDate   
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
  Error_Procedure() as 'Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetailsFetch',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
  
END CATCH  
SET NOCOUNT OFF  
END
GO
