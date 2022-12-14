USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_VehicleLicense_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_VehicleLicense_Save] (
@LicenseCodeId int,
@LicenseCode nvarchar(50),
@LicenseDescription nvarchar(50) =null,
@LicenseNo nvarchar(50),
@ClassGrade nvarchar(50),
@IssuedBy nvarchar(50)='',
@IssuedDate datetime,
@ExpiryDate datetime,
@VehicleId int,
@IsDeleted bit
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY

	IF(EXISTS(SELECT 1 FROM HWMS_VehicleDetailsLicense WHERE [LicenseCodeId] =  @LicenseCodeId AND [VehicleId]=@VehicleId and [isDeleted] = 0))    
			BEGIN
				UPDATE HWMS_VehicleDetailsLicense SET [LicenseCode] = @LicenseCode, [LicenseDescription] = @LicenseDescription,
				[LicenseNo]= @LicenseNo, [ClassGrade]= @ClassGrade, [IssuedBy]= @IssuedBy,[IssuedDate]= @IssuedDate, 
				[ExpiryDate]= @ExpiryDate, [isDeleted] = CAST(@IsDeleted AS INT)
				WHERE [LicenseCodeId] =  @LicenseCodeId AND [VehicleId]=@VehicleId
			END
	ELSE
			BEGIN
				INSERT INTO HWMS_VehicleDetailsLicense 
				([LicenseCode], [LicenseDescription], [LicenseNo], [ClassGrade], [IssuedBy], [IssuedDate], [ExpiryDate],
				[VehicleId], [isDeleted] ) 
				VALUES(@LicenseCode, @LicenseDescription, @LicenseNo,
					@ClassGrade, @IssuedBy, @IssuedDate, @ExpiryDate,@VehicleId, CAST(@IsDeleted AS INT) )
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
Error_Procedure() as 'Sp_HWMS_VehicleDetails_Save_License',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
end
GO
