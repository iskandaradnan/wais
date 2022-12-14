USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_LicenseTypeDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_HWMS_LicenseTypeDetails_Save](
@LicenseId  int,
@LicenseTypeId  int,
@LicenseCode nvarchar(50),
@LicenseDescription nvarchar(500),
@IssuingBody nvarchar(50),
@isDeleted bit
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY 
BEGIN
	IF(@LicenseId = 0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM HWMS_LicenseType_Details WHERE [LicenseCode] =  @LicenseCode and isDeleted = 0))			           
		BEGIN
			SELECT -1 AS LicenseTypeId				 
		END
		ELSE
		BEGIN
			INSERT INTO HWMS_LicenseType_Details ( [LicenseTypeId], [LicenseCode], [LicenseDescription], [IssuingBody], [isDeleted] ) 
		    VALUES( @LicenseTypeId, @LicenseCode, @LicenseDescription, @IssuingBody, CAST(@isDeleted AS INT))	
	
			SELECT @@Identity as 'LicenseId'		    
		END
	END	
	ELSE
	BEGIN
	  	UPDATE HWMS_LicenseType_Details SET [LicenseCode] = @LicenseCode, [LicenseDescription] = @LicenseDescription, [IssuingBody] = @IssuingBody,
		[isDeleted] = CAST(@isDeleted AS INT) 
		WHERE  LicenseId = @LicenseId AND LicenseTypeId=@LicenseTypeId  

		SELECT @LicenseId as LicenseId
	 END
	
			
END

END TRY
BEGIN CATCH
INSERT INTO ExceptionLog (ErrorLine, ErrorMessage, ErrorNumber,ErrorProcedure, ErrorSeverity, ErrorState,DateErrorRaised)
SELECT
ERROR_LINE () as ErrorLine,
Error_Message() as ErrorMessage,
Error_Number() as ErrorNumber,
Error_Procedure() as 'Sp_HWMS_LicenseTypeDetails_Save',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised
END CATCH
END
GO
