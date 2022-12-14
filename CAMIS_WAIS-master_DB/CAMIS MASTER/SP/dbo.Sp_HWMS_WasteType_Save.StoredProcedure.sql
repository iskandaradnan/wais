USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_WasteType_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[Sp_HWMS_WasteType_Save](  

   @WasteTypeId int,  
   @CustomerId int,  
  @FacilityId int,  
  @WasteCategory varchar(50),  
  @WasteType varchar(50))  
  AS  
BEGIN   
SET NOCOUNT ON;   
  
BEGIN TRY  
IF(@WasteTypeId = 0)  
 BEGIN  
	IF(EXISTS(SELECT 1 FROM HWMS_WasteType WHERE WasteCategory = @WasteCategory AND WasteType = @WasteType AND CustomerId = @CustomerId 
	AND FacilityId = @FacilityId))
		BEGIN
			SELECT -1 AS WasteTypeId
		END
	ELSE
		BEGIN
			 INSERT INTO HWMS_WasteType (CustomerId, FacilityId, WasteCategory, WasteType )  
		   VALUES( @CustomerId, @FacilityId,  @WasteCategory, @WasteType)                   
			 select MAX(WasteTypeId) as WasteTypeId from HWMS_WasteType  
		END
    END  
ELSE  
   BEGIN     
		--UPDATE HWMS_WasteType SET  Wastecategory = @WasteCategory, WasteType = @WasteType   
        --WHERE WasteTypeId = @WasteTypeId  
    
		SELECT @WasteTypeId AS WasteTypeId  
    END   
    
END TRY   
BEGIN CATCH    
  
 INSERT INTO ExceptionLog ( ErrorLine, ErrorMessage, ErrorNumber, ErrorProcedure, ErrorSeverity, ErrorState, DateErrorRaised )    
 SELECT    
 ERROR_LINE () as ErrorLine,    
 Error_Message() as ErrorMessage,    
 Error_Number() as ErrorNumber,    
 Error_Procedure() as 'Sp_HWMS_WasteType_Save',    
 Error_Severity() as ErrorSeverity,    
 Error_State() as ErrorState,    
 GETDATE () as DateErrorRaised    
  
 SELECT 'Error occured while inserting'  
END CATCH   
END
GO
