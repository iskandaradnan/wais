USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_ConsignmentnoteOSWCNFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec  [dbo].[SP_HWMS_ConsignmentnoteOSWCNFetch] 8, '2020-11-25' , '2020-12-14'
CREATE procedure [dbo].[SP_HWMS_ConsignmentnoteOSWCNFetch]
(
@pConsignmentOSWCNId INT,
@pStartDate DATETIME,
@pEndDate DATETIME
)
as
begin
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY 

	IF(EXISTS(select 1 from HWMS_ConsignmentNoteOSWCN_SWRSNo where  ConsignmentOSWCNId = @pConsignmentOSWCNId))
	BEGIN
		SELECT SWRSNoId, UserAreaCode, UserAreaName, SWRSNo as OSWRSNo
		 FROM HWMS_ConsignmentNoteOSWCN_SWRSNo where  ConsignmentOSWCNId = @pConsignmentOSWCNId AND [isDeleted]=0

		 
	END
	ELSE
	BEGIN		
		SELECT A.OSWRId as SWRSNoId, UserAreaCode, UserAreaName, OSWRSNo FROM HWMS_OSWRecordSheet A
		LEFT JOIN FMLovMst B ON A.Status = B.LovId 
		WHERE B.FieldValue = 'Open' and a.CreatedDate BETWEEN @pStartDate AND @pEndDate 
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
	Error_Procedure() as 'SP_HWMS_ConsignmentNoteOSWCNFetch',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
