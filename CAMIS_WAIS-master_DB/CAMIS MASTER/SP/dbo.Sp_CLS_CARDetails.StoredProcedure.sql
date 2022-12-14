USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CARDetails]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CARDetails](	
	    @Activity VARCHAR(50),
		@StartDate DATETIME,
		@TargetDate DATETIME,
		@ActualCompletionDate DATETIME=NULL,
		@Responsibility NVARCHAR(50),	
		@ResponsiblePerson NVARCHAR(50)='NULL',
		@CARId INT
		)
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	Begin
	INSERT INTO CLS_CARDetails VALUES(@Activity,@StartDate,@TargetDate,@ActualCompletionDate,@Responsibility,@ResponsiblePerson,@CARId)
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
	Error_Procedure() as 'Sp_CLS_CARDetails',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  

END CATCH
end
GO
