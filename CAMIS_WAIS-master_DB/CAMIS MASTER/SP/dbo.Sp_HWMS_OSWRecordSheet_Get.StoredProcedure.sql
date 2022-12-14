USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_OSWRecordSheet_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_OSWRecordSheet_Get]  
(  
 @Id INT  
)  
   
AS   
  
-- Exec [OSWRSheet_Get]   
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
  
 SELECT [OSWRId], A.[CustomerId], A.[FacilityId], [OSWRSNo], [TotalPackage], A.[WasteType], F.[ConsignmentNoteNo] as ConsignmentNo, [UserAreaCode], [UserAreaName], [Month], [Year], [CollectionFrequency], [CollectionType], [Status]  
 FROM HWMS_OSWRecordSheet A  
 LEFT JOIN HWMS_ConsignmentNoteOSWCN F ON A.ConsignmentNo = F.ConsignmentOSWCNId    
  where  OSWRId =  @Id  
  
 SELECT * FROM HWMS_OSWRecordSheet_OtherScheduleWasteSave where  OSWRId =  @Id AND isDeleted = 0
 
 SELECT * FROM HWMS_OSWRecordSheet_Attachment where  OSWRId =  @Id AND isDeleted = 0  


  
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
  Error_Procedure() as 'Sp_HWMS_OSWRecordSheet_Get',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
END CATCH  
END
GO
