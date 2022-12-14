USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaVariationInactive]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaVariationInactive]
					(@pUserAreaIds nvarchar(50))
AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY
					
		UPDATE  CLS_DeptAreaVariationDetails 	SET isDeleted = 0	 
		WHERE  UserAreaId  NOT IN  (SELECT Item FROM SplitString (@pUserAreaIds,',') )

	
END TRY
	BEGIN CATCH
		INSERT INTO ExceptionLog (
		ErrorLine, ErrorMessage, ErrorNumber,
		ErrorProcedure, ErrorSeverity, ErrorState,
		DateErrorRaised)
		SELECT
		ERROR_LINE () as ErrorLine,
		Error_Message() as ErrorMessage,
		Error_Number() as ErrorNumber,
		Error_Procedure() as 'Sp_CLS_DeptAreaVariationInactive',
		Error_Severity() as ErrorSeverity,
		Error_State() as ErrorState,
		GETDATE () as DateErrorRaised
	END CATCH
END
GO
