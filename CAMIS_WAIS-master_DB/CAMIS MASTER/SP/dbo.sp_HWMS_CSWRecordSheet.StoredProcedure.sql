USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CSWRecordSheet]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_HWMS_CSWRecordSheet](  
         @CSWRecordSheetId int,  
   @CustomerId int,  
   @FacilityId int,    
   @DocumentNo nvarchar(50)=null,  
   @RRWNo nvarchar(50)=null,  
         @WasteType nvarchar(50),  
   @WasteCode nvarchar(50),  
         @UserAreaCode nvarchar(50),  
   @UserAreaName nvarchar(50)=null,  
         @Month varchar(50),  
   @Year varchar(50),  
         @CollectionType nvarchar(50),  
   @Status int=null,  
   @TotalWeight float=null)  
AS  
BEGIN  
SET NOCOUNT ON;    
BEGIN TRY  
IF(@CSWRecordSheetId = 0)  
  BEGIN  
      IF(EXISTS(SELECT 1 FROM HWMS_CSWRecordSheet WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and   
   WasteType = @WasteType and UserAreaCode = @UserAreaCode and Month = @Month and Year = @Year))  
   BEGIN  
   SELECT -1 AS CSWRecordSheetId  
   END  
   ELSE  
   BEGIN  
    INSERT INTO HWMS_CSWRecordSheet ( CustomerId, FacilityId, DocumentNo, RRWNo, WasteType, WasteCode, UserAreaCode, UserAreaName,  
                                      Month, Year, CollectionType, Status, TotalWeight, CreatedDate)  
    VALUES(@CustomerId, @FacilityId, @DocumentNo, @RRWNo, @WasteType, @WasteCode, @UserAreaCode, @UserAreaName,  
           @Month, @Year,@CollectionType, @Status, @TotalWeight, GETDATE() )  
  
    SELECT MAX(CSWRecordSheetId) as CSWRecordSheetId FROM HWMS_CSWRecordSheet  
   END  
  END  
  ELSE  
  BEGIN  
     UPDATE HWMS_CSWRecordSheet SET DocumentNo = @DocumentNo, RRWNo = @RRWNo,WasteType= @WasteType,  
     WasteCode= @WasteCode,UserAreaCode= @UserAreaCode, UserAreaName = @UserAreaName,   
     Month= @Month, Year= @Year, CollectionType = @CollectionType, [Status] = @Status, ModifiedDate = GETDATE()
	 WHERE CSWRecordSheetId=@CSWRecordSheetId  
   SELECT @CSWRecordSheetId as CSWRecordSheetId  
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
 Error_Procedure() as 'sp_HWMS_CSWRecordSheet',  
 Error_Severity() as ErrorSeverity,  
 Error_State() as ErrorState,  
 GETDATE () as DateErrorRaised  
END CATCH  
END
GO
