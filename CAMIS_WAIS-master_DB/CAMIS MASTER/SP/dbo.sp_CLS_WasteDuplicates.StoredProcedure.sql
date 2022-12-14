USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_CLS_WasteDuplicates]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CLS_WasteDuplicates](@pwaste nvarchar(50))
AS
BEGIN
SET NOCOUNT ON;
--exec sp_CLS_WasteDuplicates '1'
BEGIN TRY
SELECT COUNT(1) AS 'totalCount'  FROM HWMS_WasteType_WasteCode WHERE 
	WasteCode IN ( SELECT item FROM SplitString (@pwaste , ','))
	--select *from HWMS_WasteType_WasteCode
	
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
Error_Procedure() as 'sp_CLS_WasteDuplicates',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised

SELECT 'Error occured while inserting'
END CATCH
END
GO
