USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_RecordsofRecyclableWaste_CSWRS]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_HWMS_RecordsofRecyclableWaste_CSWRS](
@UserAreaCode nvarchar(50),@UserAreaName nvarchar(50),@CSWRSNo nvarchar(50),@RecyclableId int)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY


BEGIN
INSERT INTO HWMS_RecordsofRecyclableWaste_CSWRS VALUES(@UserAreaCode,@UserAreaName,@CSWRSNo,@RecyclableId)
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
Error_Procedure() as 'SP_HWMS_RecordsofRecyclableWaste_CSWRS',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
end




GO
