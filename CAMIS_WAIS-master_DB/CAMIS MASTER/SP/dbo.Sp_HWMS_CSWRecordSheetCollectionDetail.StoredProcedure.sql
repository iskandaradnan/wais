USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CSWRecordSheetCollectionDetail]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_HWMS_CSWRecordSheetCollectionDetail] 
 @CSWId int,  
  @CSWRecordSheetId int,  
  @Date datetime,  
  @NoofBin nvarchar(50)=null,  
  @Weight float=null,  
  @CollectionFrequency int,  
  @CollectionTime datetime,  
  @CollectionStatus int,  
  @QC nvarchar(50)=null,   
  @isDeleted bit  
  
  AS 

BEGIN 

SET NOCOUNT ON; 

BEGIN TRY  



  
  IF(@CSWId = 0)  
 BEGIN  
  IF(EXISTS(SELECT 1 FROM HWMS_CSWRecordSheetCollectionDetail WHERE  [Date] = @Date AND 
	[CollectionTime] = CONVERT(TIME(7), CONVERT(VARCHAR(16), @CollectionTime , 121), 0) AND [CSWRecordSheetId] = @CSWRecordSheetId ))                
  BEGIN  
   SELECT -1 AS CSWId       
  END  
  ELSE  
  BEGIN  
   INSERT INTO HWMS_CSWRecordSheetCollectionDetail ([CSWRecordSheetId], [Date], [NoofBin], [Weight], [CollectionFrequency],  
   [CollectionTime], [CollectionStatus],[QC], [isDeleted] )   
      VALUES( @CSWRecordSheetId, @Date, @NoofBin, @Weight, @CollectionFrequency, @CollectionTime, @CollectionStatus, @QC, CAST(@isDeleted AS INT))   
   
   SELECT @@Identity as 'CSWId'        
  END  
 END   
 ELSE  
 BEGIN  
    UPDATE HWMS_CSWRecordSheetCollectionDetail SET [Date] = @Date, [NoofBin] = @NoofBin, [Weight] = @Weight,  
           [CollectionFrequency]= @CollectionFrequency, [CollectionTime]= @CollectionTime, [CollectionStatus]= @CollectionStatus, [QC] = @QC,  
           [isDeleted] = CAST(@isDeleted AS INT)   
  WHERE  CSWId = @CSWId AND CSWRecordSheetId= @CSWRecordSheetId    
  
  SELECT @CSWId as CSWId  
  END  
  END TRY 
  BEGIN CATCH  
  INSERT INTO ExceptionLog (    ErrorLine, ErrorMessage, ErrorNumber,    ErrorProcedure, ErrorSeverity, ErrorState,    DateErrorRaised    )    SELECT    ERROR_LINE () as ErrorLine,    Error_Message() as ErrorMessage,    Error_Number() as ErrorNumber,    Error_Procedure() as 'Sp_HWMS_CSWRecordSheetCollectionDetail',    Error_Severity() as ErrorSeverity,    Error_State() as ErrorState,    GETDATE () as DateErrorRaised   END CATCH 
END
GO
