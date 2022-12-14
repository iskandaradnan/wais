USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_LicenseType_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_LicenseType_Save](

@LicenseTypeId int,
@CustomerId int,
@FacilityId int,
@LicenseType varchar(50),
@WasteCategory varchar(50),
@WasteType varchar(50)
)

AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
IF(@LicenseTypeId = 0)
       BEGIN
	       INSERT INTO HWMS_LicenseType (CustomerId, FacilityId, LicenseType, WasteCategory, WasteType )
		   VALUES( @CustomerId, @FacilityId, @LicenseType, @WasteCategory, @WasteType)

	       SELECT MAX(LicenseTypeId) AS LicenseTypeId FROM HWMS_LicenseType
	   END
ELSE
	  BEGIN	
		
		UPDATE HWMS_LicenseType SET LicenseType = @LicenseType, Wastecategory = @WasteCategory, WasteType = @WasteType 
        WHERE LicenseTypeId = @LicenseTypeId
		
		SELECT @LicenseTypeId AS LicenseTypeId

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
	Error_Procedure() as 'Sp_HWMS_LicenseType_Save',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
