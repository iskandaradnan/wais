USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CARActivityTxn]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CARActivityTxn]

	@CARActivityId INT,
	@Activity VARCHAR(50),
	@StartDate DATETIME,
	@TargetDate DATETIME,
	@ActualCompletionDate DATETIME=null,
	@Responsibility NVARCHAR(50),	
	@ResponsiblePerson NVARCHAR(50)=null,
	@CARId INT,
	@isDeleted BIT
		
AS
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	BEGIN
	IF(EXISTS(SELECT 1 FROM [CLS_CARActivityTxn] WHERE CARActivityId = @CARActivityId AND [CARId] = @CARId ))
		BEGIN
			UPDATE [dbo].[CLS_CARActivityTxn]  SET [Activity] = @Activity, [StartDate] = @StartDate , [TargetDate] = @TargetDate,
			[ActualCompletionDate] = @ActualCompletionDate, [Responsibility] = @Responsibility, [ResponsiblePerson] = @ResponsiblePerson,
			[isDeleted] = CAST(@IsDeleted AS INT)  WHERE [CARActivityId] = @CARActivityId AND [CARId] = @CARId

		END
	ELSE
		BEGIN
		INSERT INTO [dbo].[CLS_CARActivityTxn] 
		([Activity] , [StartDate] ,[TargetDate] ,[ActualCompletionDate] ,[Responsibility],[ResponsiblePerson] ,[CARId], [isDeleted] )
		VALUES( @Activity, @StartDate, @TargetDate, @ActualCompletionDate, @Responsibility, @ResponsiblePerson, @CARId, CAST(@IsDeleted AS INT)  )
		END

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
