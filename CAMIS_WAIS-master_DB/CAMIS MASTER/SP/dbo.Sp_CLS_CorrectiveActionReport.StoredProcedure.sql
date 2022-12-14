USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_CorrectiveActionReport]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_CLS_CorrectiveActionReport]

    @CARId INT,
	@CustomerId INT,
	@FacilityId INT,
	@CARGeneration NVARCHAR(50)=null,
	@CARNo NVARCHAR(50)=null,
	@Indicator NVARCHAR(50),
	@CARDate DATETIME,
	@CARPeriodFrom DATETIME=null,
	@CARPeriodTo DATETIME=null,
    @FollowUpCAR NVARCHAR(50)=null,
	@Assignee NVARCHAR(50),
	@ProblemStatement NVARCHAR(50),
	@RootCause NVARCHAR(50),
	@Solution NVARCHAR(50),
	@Priority NVARCHAR(50),
    @Status NVARCHAR(50),
	@Issuer NVARCHAR(50)=null,
    @CARTargetDate DATETIME,
    @VerifiedDate DATETIME=null,
    @VerifiedBy NVARCHAR(50)=null,
    @Remarks NVARCHAR(50)=null
		 
		AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@CARId = 0)
		BEGIN
		    IF(EXISTS(SELECT 1 FROM CLS_CorrectiveActionReport WHERE[CustomerId] = @CustomerId AND [FacilityId] = @FacilityId AND [CARId] = @CARId))
			BEGIN
			SELECT -1 AS CARId
			END
			ELSE
			BEGIN
			INSERT INTO CLS_CorrectiveActionReport ([CustomerId], [FacilityId], [CARGeneration], [CARNo], [Indicator],[CARDate],[CARPeriodFrom],[CARPeriodTo],[FollowUpCAR],
			[Assignee],[ProblemStatement], [RootCause],[Solution],[Priority],[Status],[Issuer],[CARTargetDate],[VerifiedDate],[VerifiedBy],[Remarks] )				
			VALUES(@CustomerId, @FacilityId, @CARGeneration, @CARNo, @Indicator, @CARDate, @CARPeriodFrom, @CARPeriodTo, @FollowUpCAR, @Assignee,@ProblemStatement,
			@RootCause , @Solution,@Priority,@Status,@Issuer,@CARTargetDate,@VerifiedDate,@VerifiedBy,@Remarks)
				
			SELECT MAX(CARId) AS [CARId] FROM CLS_CorrectiveActionReport
			END
		END
ELSE
        BEGIN
		 UPDATE CLS_CorrectiveActionReport SET [CARGeneration] = @CARGeneration, [CARNo] = @CARNo,[Indicator]= @Indicator, [CARDate]= @CARDate,[CARPeriodFrom]= @CARPeriodFrom,
		 [CARPeriodTo] = @CARPeriodTo, [FollowUpCAR]=@FollowUpCAR, [Assignee]=@Assignee,[ProblemStatement]=@ProblemStatement , [RootCause]=@RootCause,
		 [Solution]=@Solution,[Priority]=@Priority ,[Status]=@Status,[Issuer]=@Issuer, [CARTargetDate]=@CARTargetDate, [VerifiedDate]=@VerifiedDate,
		 [VerifiedBy]=@VerifiedBy, [Remarks]=@Remarks WHERE [CARId]=@CARId

		 SELECT @CARId as CARId
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
	Error_Procedure() as 'Sp_CLS_CorrectiveActionReport',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised  


   END CATCH 
END
GO
