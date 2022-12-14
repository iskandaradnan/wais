USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_VehicleDetails_Display_LicenseCode]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[Sp_HWMS_VehicleDetails_Display_LicenseCode](
                                                              @pLicenseCode nvarchar(50)
															  )
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
select LicenseDescription,issuingBody from HWMS_LicenseTypeTableSave where LicenseCode=@pLicenseCode
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
	Error_Procedure() as 'Sp_HWMS_VehicleDetails_Display_LicenseCode',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised

	--SELECT 0 AS 'NEWID'
END CATCH
END
GO
