USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[sp_HWMS_QualityCauseMaster_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_HWMS_QualityCauseMaster_Save](
@QualityCauseMasterId INT,
@CustomerId int,
@FacilityId int,
@FailureSymptomCode varchar(500),
@Description varchar(500)
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@QualityCauseMasterId = 0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM HWMS_QualityCauseMasterTxn WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and
		FailureSymptomCode = @FailureSymptomCode))
		BEGIN
			SELECT -1 AS QualityCauseMasterId
		END
		ELSE
		BEGIN
			INSERT INTO HWMS_QualityCauseMasterTxn ( CustomerId, FacilityId, FailureSymptomCode, Description )
			VALUES( @CustomerId, @FacilityId, @FailureSymptomCode, @Description )

			SELECT MAX(QualityCauseMasterId) AS QualityCauseMasterId FROM HWMS_QualityCauseMasterTxn
		END		
	END
	ELSE
	BEGIN
		UPDATE HWMS_QualityCauseMasterTxn SET Description = @Description WHERE QualityCauseMasterId = @QualityCauseMasterId

		SELECT @QualityCauseMasterId AS QualityCauseMasterId
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
Error_Procedure() as 'sp_HWMS_QualityCauseMaster_Save',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised

SELECT 'Error occured while inserting'
END CATCH
END
GO
