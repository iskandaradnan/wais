USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_DailyCleaningActivity_Get]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_CLS_DailyCleaningActivity_Get]
(
	@Id INT
)
AS 


BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	
	--SELECT CustomerId,FacilityId,DocumentNo,Year,Month FROM CLS_PeriodicWorkRecord WHERE PeriodicId = @Id

	SELECT * FROM CLS_DailyCleaningActivity where  DailyActivityId =  @Id

	select * from CLS_DailyCleaningActivityGridviewfields where  DailyActivityId = @Id

	SELECT * FROM CLS_DailyCleaningActivity_Attachment WHERE DailyActivityId = @Id AND isDeleted = 0
	
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
		Error_Procedure() as 'SP_CLS_DailyCleaningActivity_Get',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH
SET NOCOUNT OFF
END
GO
