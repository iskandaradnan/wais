USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmetPlant_LicenseDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [dbo].[Sp_CLS_ApprovedChemicalList] 0, 25, 25, 'AirFreshener', 'Kitchen/Engineering', 'FLORIDE','ACITICACID565', 'Flamabul', 1, '2020-01-09', null

CREATE PROC [dbo].[Sp_HWMS_TreatmetPlant_LicenseDetails_Save](
        @LicenseCodeId INT,
		@LicenseCode NVARCHAR(50),
		@LicenseDescription NVARCHAR(50)= NULL,
		@LicenseNo NVARCHAR(50),
		@Class NVARCHAR(50)= NULL,
		@IssueDate DATETIME,
		@ExpiryDate DATETIME,
		@TreatmentPlantId INT,
		@IsDeleted BIT	
		)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY	
		IF(@LicenseCodeId = 0)
		BEGIN
			IF(EXISTS(SELECT 1 FROM HWMS_TreatementPlant_LicenseDetail WHERE [LicenseNo] = @LicenseNo AND [isDeleted] = 0))
			BEGIN
				SELECT -1 AS LicenseCodeId				
			END
			ELSE
			BEGIN
			INSERT INTO HWMS_TreatementPlant_LicenseDetail
			([LicenseCode],[LicenseDescription],[LicenseNo],[Class],[IssueDate],[ExpiryDate],[TreatmentPlantId],[isDeleted]) 
			VALUES(@LicenseCode, @LicenseDescription, @LicenseNo, @Class,@IssueDate,@ExpiryDate,@TreatmentPlantId,CAST(@IsDeleted AS INT))
                                              
			SELECT @@Identity AS LicenseCodeId
			END
		    END
		    ELSE
		    BEGIN
		    UPDATE HWMS_TreatementPlant_LicenseDetail SET [LicenseCode] = @LicenseCode, [LicenseDescription] = @LicenseDescription,[LicenseNo] = @LicenseNo,
		    [Class] = @Class,[IssueDate]=@IssueDate,[ExpiryDate]=@ExpiryDate,[isDeleted] = CAST(@IsDeleted AS INT) 
		    WHERE  LicenseCodeId = @LicenseCodeId AND [TreatmentPlantId] = @TreatmentPlantId

		   SELECT @LicenseCodeId AS LicenseCodeId
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
	Error_Procedure() as 'Sp_HWMS_TreatmetPlant_LicenseDetails_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
