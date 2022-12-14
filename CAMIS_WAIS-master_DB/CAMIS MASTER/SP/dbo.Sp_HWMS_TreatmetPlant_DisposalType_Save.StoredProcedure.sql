USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_TreatmetPlant_DisposalType_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_TreatmetPlant_DisposalType_Save](  
        @DisposalTypeId INT,    
		@MethodofDisposal NVARCHAR(50),
		@Status INT,
		@DesignCapacity NVARCHAR(50)='',
		@LicensedCapacity NVARCHAR(50)='',
		@Unit NVARCHAR(50),
		@TreatmentPlantId INT,	
		@IsDeleted BIT							
		)
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		IF(EXISTS(SELECT 1 FROM HWMS_TreatementPlant_DisposalType WHERE [DisposalTypeId ]=@DisposalTypeId AND [TreatmentPlantId] =@TreatmentPlantId ))
		BEGIN
		UPDATE HWMS_TreatementPlant_DisposalType SET [MethodofDisposal] = @MethodofDisposal, [Status] = @Status,[DesignCapacity]=@DesignCapacity,
		[LicensedCapacity]=@LicensedCapacity,[Unit]=@Unit,[TreatmentPlantId]=@TreatmentPlantId,[isDeleted] = CAST(@IsDeleted AS INT)
	    WHERE [DisposalTypeId]=@DisposalTypeId AND TreatmentPlantId=@TreatmentPlantId	
		END
		ELSE
		BEGIN
	    INSERT INTO HWMS_TreatementPlant_DisposalType([MethodofDisposal],[Status],[DesignCapacity],[LicensedCapacity],[Unit],[TreatmentPlantId],[isDeleted])
		VALUES(@MethodofDisposal,@Status,@DesignCapacity,@LicensedCapacity ,@Unit,@TreatmentPlantId,CAST(@IsDeleted AS INT))	
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
	Error_Procedure() as 'Sp_HWMS_TreatmetPlant_DisposalType_Save',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END

GO
