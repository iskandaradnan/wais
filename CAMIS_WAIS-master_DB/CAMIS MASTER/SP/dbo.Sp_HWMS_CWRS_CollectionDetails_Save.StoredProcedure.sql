USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRS_CollectionDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[Sp_HWMS_CWRS_CollectionDetails_Save]  
  
    @CollectionDetailsId INT,  
 @UserAreaCode VARCHAR(50),  
 @FrequencyType VARCHAR(50)=null,  
 @CollectionFequency INT,  
 @CollectionTime TIME=null,  
 @CollectionStatus VARCHAR(50),  
 @QC VARCHAR(50)=null,  
 @NoofBags INT ,  
 @NoofReceptaclesOnsite INT=null,   
 @NoofReceptacleSanitize INT=null,  
 @Sanitize VARCHAR(50)=null,  
 @CWRecordSheetId INT,  
 @IsDeleted BIT   
    
AS  
BEGIN   
SET NOCOUNT ON;   
BEGIN TRY  
    
IF(EXISTS(SELECT 1 FROM HWMS_CWRS_CollectionDetails_Save WHERE [CollectionDetailsId]=@CollectionDetailsId AND [CWRecordSheetId] =@CWRecordSheetId ))  
 BEGIN  
 UPDATE HWMS_CWRS_CollectionDetails_Save SET [UserAreaCode] = @UserAreaCode, [FrequencyType] = @FrequencyType,[CollectionFrequency]=@CollectionFequency,  
 [CollectionTime]=@CollectionTime,[CollectionStatus]=@CollectionStatus,[QC]=@QC,[NoofBags]=@NoofBags,[NoofReceptaclesOnsite]=@NoofReceptaclesOnsite,  
 [NoofReceptacleSanitize]=@NoofReceptacleSanitize,[Sanitize]=@Sanitize,[CWRecordSheetId]=@CWRecordSheetId,[isDeleted] = CAST(@IsDeleted AS INT)   
 WHERE [CollectionDetailsId]=@CollectionDetailsId AND [CWRecordSheetId] =@CWRecordSheetId   
 END  
ELSE  
 BEGIN  
 INSERT INTO HWMS_CWRS_CollectionDetails_Save([UserAreaCode],[FrequencyType],[CollectionFrequency],[CollectionTime],[CollectionStatus],[QC],[NoofBags],  
 [NoofReceptaclesOnsite],[NoofReceptacleSanitize],[Sanitize],[CWRecordSheetId],[isDeleted])  
 VALUES(@UserAreaCode,@FrequencyType,@CollectionFequency,@CollectionTime,@CollectionStatus,@QC, @NoofBags,@NoofReceptaclesOnsite,@NoofReceptacleSanitize,  
 @Sanitize,@CWRecordSheetId,CAST(@IsDeleted AS INT))    
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
 Error_Procedure() as 'Sp_HWMS_CWRS_CollectionDetails_Save',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
  
 SELECT 'Error occured while inserting'  
END CATCH   
END
GO
