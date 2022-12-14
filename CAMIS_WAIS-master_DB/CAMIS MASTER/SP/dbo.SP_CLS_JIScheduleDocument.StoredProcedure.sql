USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_JIScheduleDocument]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_CLS_JIScheduleDocument](
@DocumentNo nvarchar(50),
@UserAreaCode nvarchar(30),
@UserAreaName nvarchar(30),
@Day nvarchar(30),
@TargetDate nvarchar(30),
@Status int,
@JIId int
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@JIId = 0)


BEGIN

INSERT INTO CLS_JIScheduleDocument VALUES(@DocumentNo,@UserAreaCode,@UserAreaName,@Day,@TargetDate,@Status,@JIId)

END
else
begin
 UPDATE CLS_JIScheduleDocument SET DocumentNo = @DocumentNo, UserAreaCode = @UserAreaCode, UserAreaName = @UserAreaName,
 Day=@Day,TargetDate=@TargetDate,Status=@Status WHERE JIId = @JIId
	 SELECT @JIId
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
Error_Procedure() as 'SP_CLS_JIScheduleDocument',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
end
GO
