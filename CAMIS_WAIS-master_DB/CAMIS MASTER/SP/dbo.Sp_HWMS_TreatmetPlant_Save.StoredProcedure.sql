USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmetPlant_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_HWMS_TreatmetPlant_Save](
		@TreatmentPlantId INT,
		@Customerid INT,
		@Facilityid INT,
		@TreatmentPlantCode NVARCHAR(50) ,
		@TreatmentPlantName NVARCHAR(50),
		@RegistrationNo NVARCHAR(50)= NULL,
		@AdressLine1 NVARCHAR(100) ,
		@AdressLine2 NVARCHAR(100)= NULL,
		@City NVARCHAR(50),
		@State NVARCHAR(50) ,
		@PostCode NVARCHAR(50),
		@Ownership NVARCHAR(50),
		@ContactNumber BIGINT ,
		@FaxNumber NVARCHAR(50)= NULL,
		@DOEFileNo NVARCHAR(50),
		@OwnerName NVARCHAR(50) ,
		@NumberOfStore INT,				
		@CapacityOfStorage INT,
		@Remarks NVARCHAR(100)= NULL
		)
AS
BEGIN 
SET NOCOUNT ON; 
BEGIN TRY

	IF(@TreatmentPlantId = 0)
	BEGIN
	IF(NOT EXISTS (SELECT 1 FROM HWMS_TreatementPlant WHERE CustomerId = @Customerid and FacilityId = @Facilityid and TreatmentPlantCode = @TreatmentPlantCode))
		BEGIN
		INSERT INTO HWMS_TreatementPlant([CustomerId],[FacilityId],[TreatmentPlantCode],[TreatmentPlantName],[RegistrationNo],[AdressLine1],[AdressLine2],[City],[State],
		[PostCode],[Ownership],[ContactNumber],[FaxNumber],[DOEFileNo],[OwnerName],[NumberOfStore],[CapacityOfStorage],[Remarks])
		VALUES(@Customerid,@Facilityid,@TreatmentPlantCode,@TreatmentPlantName ,@RegistrationNo,@AdressLine1,@AdressLine2,@City,@State,
		@PostCode,@Ownership,@ContactNumber,@FaxNumber,@DOEFileNo,@OwnerName,@NumberOfStore,@CapacityOfStorage,@Remarks)
		--SET @NewChemicalID = @@IDENTITY
		SELECT MAX(TreatmentPlantId) AS TreatmentPlantId FROM HWMS_TreatementPlant
		END
	ELSE
		BEGIN
		SELECT -1 AS TreatmentPlantId
		END		
	END
	ELSE
		BEGIN		 
		UPDATE HWMS_TreatementPlant SET [TreatmentPlantCode] = @TreatmentPlantCode, [TreatmentPlantName] = @TreatmentPlantName,[RegistrationNo]=@RegistrationNo,
		[AdressLine1]=@AdressLine1,[AdressLine2]=@AdressLine2,[City]=@City,[State]=@State,[PostCode]=@PostCode,[Ownership]=@Ownership,[ContactNumber]=@ContactNumber,
		[FaxNumber]=@FaxNumber,[DOEFileNo]=@DOEFileNo,[OwnerName]=@OwnerName,[NumberOfStore]=@NumberOfStore,[CapacityOfStorage]=@CapacityOfStorage,[Remarks]=@Remarks
	    WHERE [TreatmentPlantId]=@TreatmentPlantId
		
		SELECT @TreatmentPlantId AS TreatmentPlantId
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
	Error_Procedure() as 'Sp_HWMS_TreatmetPlant_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
