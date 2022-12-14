USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_DriverDetailsLicense_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_DriverDetailsLicense_Save](
@LicenseCodeId int,
@DriverId int,
@LicenseCode nvarchar(50),
@Description nvarchar(50)=null,
@LicenseNo nvarchar(50),
@ClassGrade nvarchar(50),
@IssuedBy nvarchar(50)='',
@IssuedDate datetime,
@ExpiryDate datetime,
@IsDeleted bit

)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
	IF(EXISTS(SELECT 1 FROM HWMS_DriverDetailsLicense WHERE LicenseCodeId =  @LicenseCodeId AND DriverId=@DriverId ))    
		BEGIN
			UPDATE HWMS_DriverDetailsLicense SET [LicenseCode] = @LicenseCode, [Description] = @Description,
			[LicenseNo]= @LicenseNo, [ClassGrade]= @ClassGrade, [IssuedBy]= @IssuedBy,[IssuedDate]= @IssuedDate, 
			[ExpiryDate]= @ExpiryDate, [isDeleted] = CAST(@IsDeleted AS INT)
			WHERE LicenseCodeId =  @LicenseCodeId AND DriverId=@DriverId
		END
	ELSE
		BEGIN
			INSERT INTO HWMS_DriverDetailsLicense 
			([DriverId], [LicenseCode], [Description], [LicenseNo], [ClassGrade], [IssuedBy], [IssuedDate], [ExpiryDate],[isDeleted] ) 		
			VALUES(@DriverId, @LicenseCode, @Description, @LicenseNo,
	        @ClassGrade, @IssuedBy, @IssuedDate, @ExpiryDate, CAST(@IsDeleted AS INT) )
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
Error_Procedure() as 'Sp_HWMS_DriverDetailsLicense',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
end
GO
