USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_CLS_QualityCauseMaster_Save]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- ALTER Date: <ALTER Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SP_CLS_QualityCauseMaster_Save]
-- SELECT * FROM CLS_QualityCauseMasterTxn
-- select * from CLS_QualityCauseMasterTxn_Failure
    -- Add the parameters for the stored procedure here
@QualityCauseMasterId INT,
@CustomerId int,
@FacilityId int,
@FailureSymptomCode varchar(500),
@Description varchar(500)
  

AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY

		
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
	IF(@QualityCauseMasterId = 0)
	BEGIN
		IF(EXISTS(SELECT 1 FROM CLS_QualityCauseMasterTxn WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and
		FailureSymptomCode = @FailureSymptomCode))
		BEGIN
			SELECT -1 AS QualityCauseMasterId
		END
		ELSE
		BEGIN
			INSERT INTO CLS_QualityCauseMasterTxn ( CustomerId, FacilityId, FailureSymptomCode, Description )
			VALUES( @CustomerId, @FacilityId, @FailureSymptomCode, @Description )

			SELECT MAX(QualityCauseMasterId) AS QualityCauseMasterId FROM CLS_QualityCauseMasterTxn
		END		
	END
	ELSE
	BEGIN
		UPDATE CLS_QualityCauseMasterTxn SET Description = @Description WHERE QualityCauseMasterId = @QualityCauseMasterId

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
Error_Procedure() as 'SP_CLS_QualityCauseMaster',
Error_Severity() as ErrorSeverity,
Error_State() as ErrorState,
GETDATE () as DateErrorRaised

SELECT 'Error occured while inserting'
END CATCH
END
GO
