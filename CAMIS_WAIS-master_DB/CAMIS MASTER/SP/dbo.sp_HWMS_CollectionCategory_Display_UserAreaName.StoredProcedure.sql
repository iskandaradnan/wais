USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_CollectionCategory_Display_UserAreaName]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_CollectionCategory_Display_UserAreaName]
(
@UserAreaCode nvarchar(50)
)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
select UserAreaName from MstLocationUserArea where UserAreaCode=@UserAreaCode
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
	Error_Procedure() as 'sp_HWMS_CollectionCategory_Display_UserAreaName',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised

	--SELECT 0 AS 'NEWID'
END CATCH
END

GO
