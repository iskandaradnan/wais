USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_GetAttachmentList]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_GetAttachmentList] 

	@Id INT,
	@ScreenName VARCHAR(500)
	
AS 
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	  IF(@ScreenName = 'ApprovedChemicalList')
	  BEGIN
		SELECT * FROM CLS_ACL_Attachment WHERE ChemicalId = @Id AND isDeleted = 0
		-- update CLS_ACL_Attachment set isDeleted = 0
	  END
	  ELSE IF(@ScreenName = 'DailyCleaningActivity')
	  BEGIN
		SELECT * FROM CLS_DailyCleaningActivity_Attachment WHERE DailyActivityId = @Id AND isDeleted = 0
		-- update CLS_DailyCleaningActivity_Attachment set isDeleted = 0
	  END
	  ELSE IF(@ScreenName = 'FETC')
	  BEGIN
		SELECT * FROM CLS_FETC_Attachment WHERE FETCId = @Id AND isDeleted = 0
		-- update CLS_FETC_Attachment set isDeleted = 0
	  END
	  ELSE IF(@ScreenName = 'PeriodicWorkRecord')
	  BEGIN
		SELECT * FROM CLS_PeriodicWorkRecord_Attachment WHERE PeriodicId = @Id AND isDeleted = 0
		-- update CLS_PeriodicWorkRecord_Attachment set isDeleted = 0
	  END
	  ELSE IF(@ScreenName = 'ToiletInspection')
	  BEGIN
		SELECT * FROM CLS_ToiletInspectionTxn_Attachment WHERE ToiletInspectionId = @Id AND isDeleted = 0
		-- update CLS_ToiletInspectionTxn_Attachment set isDeleted = 0
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
		Error_Procedure() as 'ApprovedChemicalList_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	

END CATCH
SET NOCOUNT OFF
END
GO
