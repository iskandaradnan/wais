USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_ApprovedChemicalList]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_CLS_ApprovedChemicalList]
		@ChemicalId INT,
		@Customerid INT,
		@Facilityid INT,
		@Category VARCHAR(50),
		@AreaofApplication VARCHAR(50),
		@ChemicalName VARCHAR(50),
		@KKMNumber VARCHAR(50),
		@Properties VARCHAR(50),
		@Status INT,
		@EffectiveFromDate DATE,
		@EffectiveFTodate DATE = null		
AS

BEGIN 
SET NOCOUNT ON; 
BEGIN TRY

	IF(@ChemicalId = 0)
	BEGIN
		IF(NOT EXISTS (SELECT 1 FROM CLS_ApprovedChemicalList WHERE CustomerId = @Customerid and FacilityId = @Facilityid and KKMNumber = @KKMNumber))
			BEGIN
				INSERT INTO CLS_ApprovedChemicalList values ( @Customerid, @Facilityid, @Category, @AreaofApplication,@ChemicalName,
		@KKMNumber, @Properties, @Status, @EffectiveFromDate, @EffectiveFTodate )
			SELECT @@Identity as 'ChemicalId'
			END
		ELSE
			BEGIN
				SELECT 'KKMNumber already exists'
			END		
	END
	ELSE
		BEGIN		 
			UPDATE CLS_ApprovedChemicalList SET Category = @Category, AreaofApplication = @AreaofApplication, ChemicalName = @ChemicalName, KKMNumber = @KKMNumber,
			Properties = @Properties, [Status] = @Status, EffectiveFromDate = @EffectiveFromDate, EffectiveTodate = @EffectiveFTodate WHERE ChemicalId = @ChemicalId
			AND CustomerId = @Customerid AND FacilityId = @Facilityid
			SELECT @ChemicalId as 'ChemicalId'
		END
		
END TRY 
BEGIN CATCH  

	INSERT INTO ExceptionLog (  
	ErrorLine, ErrorMessage, ErrorNumber,  
	ErrorProcedure, ErrorSeverity, ErrorState,  
	DateErrorRaised  )  
	SELECT  
	ERROR_LINE () as ErrorLine,  
	Error_Message() as ErrorMessage,  
	Error_Number() as ErrorNumber,  
	Error_Procedure() as 'Sp_CLS_ApprovedChemicalList',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

	SELECT 'Error occured while inserting'
END CATCH 
END
						
	
GO
