USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SP_HWMS_DeptAreaDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[SP_HWMS_DeptAreaDetails_Save] 

CREATE PROC [dbo].[SP_HWMS_DeptAreaDetails_Save](@pDeptAreaId int,
      @pUserAreaId int,
      @pCustomerId int,
	  @pFacilityId int,
	  @pUserAreaCode nvarchar(50),
	  @pUserAreaName nvarchar(100)= null,
	  @pEffectiveFromDate datetime=null,
      @pEffectiveToDate datetime=null,
	  @pOperationalDays nvarchar(30),
	  @pStatus int,
	  @pCategory nvarchar(30),
	  @pRemarks nvarchar(100)= null
	)
AS
BEGIN
SET NOCOUNT ON;		
BEGIN TRY
IF(@pDeptAreaId = 0)
     BEGIN
   IF(NOT EXISTS(SELECT 1 FROM HWMS_DeptAreaDetails WHERE CustomerId = @pCustomerid and FacilityId = @pFacilityid and UserAreaCode = @pUserAreaCode))
     BEGIN	
     INSERT INTO HWMS_DeptAreaDetails([UserAreaId],[CustomerId],[FacilityId],[UserAreaCode],[UserAreaName],[EffectiveFromDate],[EffectiveToDate],
	 [OperatingDays],[Status],[Category],[Remarks] )
	 VALUES(
	 @pUserAreaId,@pCustomerId, @pFacilityId, @pUserAreaCode,	@pUserAreaName,@pEffectiveFromDate,	@pEffectiveToDate,	@pOperationalDays,
	 @pStatus,@pCategory,@pRemarks)
            		
     SELECT MAX([DeptAreaId]) AS DeptAreaId FROM HWMS_DeptAreaDetails
    END
  ELSE
	BEGIN
	SELECT 'UserAreaCode already exists'
	END	
	END
ELSE
	BEGIN
		-- UPDATE
		UPDATE HWMS_DeptAreaDetails SET [EffectiveFromDate]=@pEffectiveFromDate,[EffectiveToDate]=@pEffectiveToDate,
		[OperatingDays] = @pOperationalDays,[Category]=@pCategory,[Status]=@pStatus,[Remarks]=@pRemarks
		WHERE [UserAreaCode] = @pUserAreaCode AND [CustomerId] = @pCustomerId AND [FacilityId] = @pFacilityId 
				
		SELECT @pDeptAreaId as DeptAreaId
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
	Error_Procedure() as 'SP_HWMS_DeptAreaDetails',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
	SELECT 'Error occured while inserting'
	--SELECT 0 AS 'NEWID'
END CATCH
END




		
		





	





GO
