USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRecordSheet_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CWRecordSheet_Save]

	@CWRecordSheetId INT,
	@CustomerId INT,
	@FacilityId INT,
	@Date DATETIME,
	@TotalUserArea INT=null,
	@TotalBagCollected INT=null,
	@TotalSanitized INT=null				
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY					
IF(@CWRecordSheetId = 0)
	
 IF(NOT EXISTS (SELECT 1 FROM HWMS_CWRecordSheet_Save WHERE [CustomerId] = @CustomerId AND [FacilityId] = @FacilityId AND [Date] = @Date))
	BEGIN
	INSERT INTO HWMS_CWRecordSheet_Save([CustomerId],[FacilityId],[Date],[TotalUserArea],[TotalBagCollected],[TotalSanitized])
	VALUES(@CustomerId,@FacilityId,@Date,@TotalUserArea,@TotalBagCollected,@TotalSanitized)

	SELECT MAX([CWRecordSheetId]) AS CWRecordSheetId FROM HWMS_CWRecordSheet_Save	
	END
 ELSE
	BEGIN
	SELECT -1 AS CWRecordSheetId
	END		
	
ELSE
		BEGIN		 
		UPDATE HWMS_CWRecordSheet_Save SET [Date] = @Date, [TotalUserArea] = @TotalUserArea,[TotalBagCollected]=@TotalBagCollected,[TotalSanitized]=@TotalSanitized				
	    WHERE [CWRecordSheetId]=@CWRecordSheetId
		
		SELECT @CWRecordSheetId AS CWRecordSheetId
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
	Error_Procedure() as 'SP_HWMS_CWRecordSheet_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
