USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_IndicatorMaster_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_HWMS_IndicatorMaster_Save]

    @IndicatorMasterId INT,
	@Customerid INT,
	@Facilityid INT,
	@IndicatorNo VARCHAR(100),
    @IndicatorName VARCHAR(100)=null,		
	@IndicatorStandard NUMERIC 								
		
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
		IF(@IndicatorMasterId = 0)
		BEGIN
		INSERT INTO HWMS_IndicatorMaster([Customerid], [Facilityid], [IndicatorNo], [IndicatorName],[IndicatorStandard], [CreatedDate])
		VALUES(@Customerid,@Facilityid,@IndicatorNo,@IndicatorName ,@IndicatorStandard, GETDATE())

		SELECT MAX([IndicatorMasterId]) AS IndicatorMasterId FROM HWMS_IndicatorMaster
	
		END
		ELSE
		BEGIN
		--UPDATE
		UPDATE HWMS_IndicatorMaster SET [IndicatorNo] = @IndicatorNo, [IndicatorName] = @IndicatorName,[IndicatorStandard]=@IndicatorStandard,[ModifiedDate]=GETDATE()
	    WHERE [IndicatorMasterId]=@IndicatorMasterId

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
	Error_Procedure() as 'SP_HWMS_IndicatorMaster_Save',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END

GO
