USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_DailyCleaningActivity]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SELECT * FROM CLS_DailyCleaningActivity
CREATE procedure [dbo].[sp_CLS_DailyCleaningActivity](
@DailyActivityId int, 
@CustomerId int,
@FacilityId int,
@DocumentNo varchar(30)='',
@Date datetime,
@TotalDone int='',
@TotalNotDone int=''	
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

	IF(@DailyActivityId=0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM CLS_DailyCleaningActivity WHERE [Date] = @Date AND CustomerId= @CustomerId AND FacilityId = @FacilityId))
		BEGIN
				SELECT -1 AS DailyActivityId, DocumentNo from CLS_DailyCleaningActivity
		END
		ELSE
		BEGIN
			INSERT INTO CLS_DailyCleaningActivity VALUES(@CustomerId,@FacilityId,@DocumentNo,@Date,@TotalDone,@TotalNotDone)
			SELECT MAX(DailyActivityId) AS DailyActivityId FROM CLS_DailyCleaningActivity
		END
	END
	ELSE
	BEGIN
		UPDATE CLS_DailyCleaningActivity SET Date = @Date ,TotalDone = @TotalDone, TotalNotDone =  @TotalNotDone WHERE DailyActivityId=@DailyActivityId
		SELECT @DailyActivityId  AS DailyActivityId
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
	Error_Procedure() as 'sp_CLS_DailyCleaningActivity',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  
END CATCH
end
GO
