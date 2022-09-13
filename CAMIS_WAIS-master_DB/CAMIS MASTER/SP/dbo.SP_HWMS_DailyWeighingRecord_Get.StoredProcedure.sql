USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_DailyWeighingRecord_Get]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[SP_HWMS_DailyWeighingRecord_Get] 40  
CREATE proc [dbo].[SP_HWMS_DailyWeighingRecord_Get]  
(  
 @DWRId INT  
)  
AS  
BEGIN  
SET NOCOUNT ON  
BEGIN TRY  
  SELECT [DWRId], A.[CustomerId], A.[FacilityId], [DWRNo], A.[TotalWeight], [Date], [TotalBags],   
  A.[TotalNoofBins], A.[HospitalRepresentative], B.ConsignmentNoteNo as [ConsignmentNo], [Status]  
  FROM HWMS_DailyWeighingRecord A  
  LEFT JOIN HWMS_ConsignmentNoteCWCN B ON A.ConsignmentNo = B.ConsignmentId    
   where  A.DWRId =  @DWRId  
  
  SELECT * FROM HWMS_DailyWeighingRecordBinNo_Save where  DWRId =  @DWRId AND [isDeleted]=0   

  SELECT * FROM HWMS_DailyWeighingRecord_Attachment where  DWRId =  @DWRId AND [isDeleted]=0   


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
  Error_Procedure() as 'SP_HWMS_DailyWeighingRecord_Get',    
  Error_Severity() as ErrorSeverity,    
  Error_State() as ErrorState,    
  GETDATE () as DateErrorRaised     
END CATCH  
END
GO
