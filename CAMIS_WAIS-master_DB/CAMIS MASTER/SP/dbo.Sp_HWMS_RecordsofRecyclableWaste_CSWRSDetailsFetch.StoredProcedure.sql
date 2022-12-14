USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetailsFetch]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetailsFetch] 

 @StartDate DATETIME,
 @EndDate DATETIME
	
AS 
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

 BEGIN
 SELECT UserAreaCode, UserAreaName, DocumentNo  FROM HWMS_CSWRecordSheet  	
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
		Error_Procedure() as 'Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetailsFetch',  
		Error_Severity() as ErrorSeverity,  
		Error_State() as ErrorState,  
		GETDATE () as DateErrorRaised  	

END CATCH
SET NOCOUNT OFF
END

GO
