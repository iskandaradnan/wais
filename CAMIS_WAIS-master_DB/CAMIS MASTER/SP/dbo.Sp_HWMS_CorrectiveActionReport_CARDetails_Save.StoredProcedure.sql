USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CorrectiveActionReport_CARDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CorrectiveActionReport_CARDetails_Save]

    @CARActivityId INT,
	@Activity VARCHAR(50),
	@StartDate DATETIME,
	@TargetDate DATETIME,
	@ActualCompletionDate DATETIME=null,
	@Responsibility NVARCHAR(50)=null,	
	@ResponsiblePerson NVARCHAR(50)=null,
	@CARId INT,
	@IsDeleted BIT
		
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
	IF(EXISTS(SELECT 1 FROM HWMS_CorrectiveActionReport_CARDetails WHERE [CARDetailsId] = @CARActivityId AND [CARId]=@CARId ))
		BEGIN 
		UPDATE HWMS_CorrectiveActionReport_CARDetails SET  [Activity] = @Activity,[StartDate] = @StartDate,[TargetDate]=@TargetDate,
		[ActualCompletionDate]=@ActualCompletionDate,[Responsibility]=@Responsibility,[ResponsiblePerson]=@ResponsiblePerson,[isDeleted] = CAST(@IsDeleted AS INT)  		                               									   
	   
		WHERE  [CARDetailsId] = @CARActivityId AND [CARId]=@CARId
					
		END
	ELSE
		BEGIN
		INSERT INTO HWMS_CorrectiveActionReport_CARDetails([Activity],[StartDate],[TargetDate],[ActualCompletionDate],[Responsibility],
		[ResponsiblePerson],[CARId],[isDeleted])		
		VALUES (@Activity, @StartDate, @TargetDate, @ActualCompletionDate,@Responsibility ,@ResponsiblePerson,@CARId, CAST(@IsDeleted AS INT) )											 		
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
	Error_Procedure() as 'Sp_HWMS_HWMS_CorrectiveActionReport_CARDetails_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  


   END CATCH 
END

GO
