USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_ChemicalInUseChemicals]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CLS_ChemicalInUseChemicals](	
		@CategoryId INT ,	
		@ChemicalInUseId INT,
		@Category INT,
		@AreaOfApplication INT,
		@ChemicalId INT,
		@KMMNo nvarchar(50)='',
		@Properties nvarchar(50)='',
		@Status INT='',
		@EffectiveDate DATE=null,
		@IsDeleted bit	)
AS
BEGIN
SET NOCOUNT ON; 
		BEGIN TRY
		IF(EXISTS(SELECT 1 FROM CLS_ChemicalInUseChemicals WHERE CategoryId = @CategoryId ))
		BEGIN 
		UPDATE CLS_ChemicalInUseChemicals SET  ChemicalInUseId = @ChemicalInUseId,Category = @Category,AreaOfApplication=@AreaOfApplication,
		ChemicalId=@ChemicalId,KMMNo=@KMMNo,Properties=@Properties, Status=@Status, EffectiveDate=@EffectiveDate,	 		                               									   
	    [isDeleted] = CAST(@IsDeleted AS INT) 
		 WHERE  CategoryId = @CategoryId 

					
		END
		ELSE
		BEGIN
		INSERT INTO CLS_ChemicalInUseChemicals VALUES (
		@ChemicalInUseId, @Category, @AreaOfApplication, @ChemicalId,
		@KMMNo ,@Properties, @Status, @EffectiveDate,  CAST(@IsDeleted AS INT) )
								 		
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
		Error_Procedure() as 'SP_CLS_ChemicalInUseChemicals',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	
END CATCH 
end
GO
