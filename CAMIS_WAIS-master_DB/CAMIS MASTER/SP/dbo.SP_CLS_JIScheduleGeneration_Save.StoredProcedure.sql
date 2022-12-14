USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_JIScheduleGeneration_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec SP_CLS_JIScheduleGeneration_Save 0, 25, 25, 2019, 1,2
CREATE procedure [dbo].[SP_CLS_JIScheduleGeneration_Save](
@JIId INT,
@CustomerId int,
@FacilityId int,
@Year int ,
@Month nvarchar(30),
@Week int
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY


IF(NOT EXISTS(SELECT 1 FROM CLS_JIScheduleGeneration WHERE CustomerId = @CustomerId AND FacilityId = @FacilityId AND [Year] = @Year 
AND [Month] = @Month AND [Week] = @Week))

	BEGIN

	INSERT INTO CLS_JIScheduleGeneration VALUES(@CustomerId,@FacilityId,@Year,@Month,@Week)
	SELECT max(JIId) as JIId from CLS_JIScheduleGeneration

	END
ELSE
	BEGIN
	-- UPDATE CLS_JIScheduleGeneration SET Year = @Year, Month = @Month, Week = @Week WHERE JIId = @JIId
	Delete from CLS_JIScheduleDocument where JIId=@JIId
	SELECT @JIId as JIId

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
Error_Procedure() as 'SP_CLS_JIScheduleGeneration_Save',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END



	
GO
