USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_DeptAreaDetail_Display_ItemCode]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_HWMS_DeptAreaDetail_Display_ItemCode](
                                                              @pItemCode nvarchar(50)
															  )
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
select ItemName,Size,UOM from HWMS_ConsumablesReceptaclesFields where ItemCode=@pItemCode
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
	Error_Procedure() as 'SP_HWMS_DeptAreaDetail_Display_ItemCode',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised

	--SELECT 0 AS 'NEWID'
END CATCH
END


GO
