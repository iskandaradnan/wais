USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CorrectiveActionReport_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Sp_HWMS_CorrectiveActionReport_Save]
(
        @CARId INT,
		@CustomerId INT,
		@FacilityId INT,
		@CARGeneration NVARCHAR(50)=null,
		@CARNo NVARCHAR(50)=null,
		@Indicator NVARCHAR(50),
		@CARDate DATETIME,
		@CARPeriodFrom DATETIME=NULL,
	    @CARPeriodTo DATETIME=NULL,
        @FollowUpCAR NVARCHAR(50)=null,
	    @Assignee NVARCHAR(50),
	    @ProblemStatement NVARCHAR(50),
	    @RootCause NVARCHAR(50),
	    @Solution NVARCHAR(50),
	    @Priority NVARCHAR(50),
        @Status NVARCHAR(50),
	    @Issuer NVARCHAR(50)=null,
        @CARTargetDate DATETIME,
        @VerifiedDate DATETIME=NULL,
        @VerifiedBy NVARCHAR(50)=null,
        @Remarks NVARCHAR(50)=null
		 )
		AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
IF(@CARId = 0)
		BEGIN
		    IF(EXISTS(SELECT 1 FROM HWMS_CorrectiveActionReport WHERE CustomerId = @CustomerId and FacilityId = @FacilityId and CARId = @CARId))
			BEGIN
			SELECT -1 AS CARId
			END
			ELSE
			BEGIN
				INSERT INTO HWMS_CorrectiveActionReport ( CustomerId, FacilityId, CARGeneration, CARNo, Indicator,CARDate,CARPeriodFrom,CARPeriodTo,FollowUpCAR,Assignee,ProblemStatement, RootCause,
				Solution,Priority,Status,Issuer,CARTargetDate,VerifiedDate,VerifiedBy, Remarks )
				VALUES(@CustomerId, @FacilityId, @CARGeneration, @CARNo, @Indicator, @CARDate, @CARPeriodFrom, @CARPeriodTo, @FollowUpCAR, @Assignee,@ProblemStatement ,@RootCause , @Solution,
				@Priority,@Status,@Issuer,@CARTargetDate,@VerifiedDate,@VerifiedBy,@Remarks)

				SELECT MAX(CARId) as CARId FROM HWMS_CorrectiveActionReport
			END
		END
		ELSE
		BEGIN
		 UPDATE HWMS_CorrectiveActionReport SET CARGeneration = @CARGeneration, CARNo = @CARNo,Indicator= @Indicator,
		 CARDate= @CARDate,CARPeriodFrom= @CARPeriodFrom, CARPeriodTo = @CARPeriodTo, FollowUpCAR=@FollowUpCAR, Assignee=@Assignee,ProblemStatement=@ProblemStatement , RootCause=@RootCause,
		 Solution=@Solution,Priority=@Priority ,Status=@Status,Issuer=@Issuer, CARTargetDate=@CARTargetDate,
		 VerifiedDate=@VerifiedDate,VerifiedBy=@VerifiedBy, Remarks=@Remarks WHERE CARId=@CARId

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
	Error_Procedure() as 'Sp_HWMS_CorrectiveActionReport_Save',  
	Error_Severity() as ErrorSeverity,  
	Error_State() as ErrorState,  
	GETDATE () as DateErrorRaised 
	 END CATCH 
END
GO
