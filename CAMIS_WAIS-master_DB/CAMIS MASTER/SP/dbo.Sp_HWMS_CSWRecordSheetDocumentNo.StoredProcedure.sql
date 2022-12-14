USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CSWRecordSheetDocumentNo]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CSWRecordSheetDocumentNo]
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

SELECT  top 1 'HWMS/CSWRS/' + convert(varchar, getdate() , 112) + '/' + REPLICATE('0', 6-LEN(convert(int, SUBSTRING(DocumentNo, 21, 30))))
 + CONVERT(varchar, convert(int, SUBSTRING(DocumentNo, 21, 30) + 1))
as DocumentNo FROM HWMS_CSWRecordSheet order by CSWRecordSheetId desc



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
Error_Procedure() as 'Sp_HWMS_CSWRecordSheetDocumentNo',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
