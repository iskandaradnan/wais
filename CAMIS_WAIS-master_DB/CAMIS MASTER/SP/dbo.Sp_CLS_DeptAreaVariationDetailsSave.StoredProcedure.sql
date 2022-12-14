USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CLS_DeptAreaVariationDetailsSave]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Sp_CLS_DeptAreaVariationDetailsSave] (

 @pDeptAreaId int, @pUserAreaId int, 
 @pAreacode varchar(25), @pAreaname varchar(100)='',
  @pSNFReference varchar(100) = null, @pVariationStatus int = null, @pSqft int = null, @pPrice decimal = null, @pCommissioningDate datetime = null,
 @pServiceStartDate datetime = null, @pWarrentyEndDate datetime = null, @pVariationDate datetime = null, @pServiceStopDate datetime = null, @isDeleted bit )
														 
AS

BEGIN

SET NOCOUNT ON;

BEGIN TRY

 IF(EXISTS( SELECT 1 FROM CLS_DeptAreaVariationDetails WHERE DeptAreaId = @pDeptAreaId AND UserAreaId = @pUserAreaId ))
	BEGIN

	UPDATE CLS_DeptAreaVariationDetails SET
	DeptAreaId = @pDeptAreaId, UserAreaId = @pUserAreaId,  Areacode = @pAreacode, Areaname = @pAreaname, SNFReferenceNo = @pSNFReference, 
	 VariationStatus = @pVariationStatus,  Sqft = @pSqft,  Price = @pPrice,  CommissioningDate = @pCommissioningDate,
	  ServiceStartDate = @pServiceStartDate,  WarrentyEndDate = @pWarrentyEndDate,  VariationDate = @pVariationDate, 
	  ServiceStopDate = @pServiceStopDate, [isDeleted] = CAST(@isDeleted AS INT) 
	  WHERE DeptAreaId = @pDeptAreaId  AND UserAreaId = @pUserAreaId 

	SELECT * FROM CLS_DeptAreaVariationDetails WHERE DeptAreaId = @pDeptAreaId  AND UserAreaId = @pUserAreaId  and isDeleted = 0

	END
  ELSE
	BEGIN

	
	INSERT INTO CLS_DeptAreaVariationDetails VALUES (
	@pDeptAreaId, @pUserAreaId,  @pAreacode, @pAreaname, @pSNFReference,  @pVariationStatus,
	  @pSqft,  @pPrice,  @pCommissioningDate, @pServiceStartDate,  @pWarrentyEndDate,  @pVariationDate,  @pServiceStopDate ,
	   CAST(@isDeleted AS INT)  )

	SELECT * FROM CLS_DeptAreaVariationDetails WHERE DeptAreaId = @pDeptAreaId  AND UserAreaId = @pUserAreaId and isDeleted = 0

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
	Error_Procedure() as 'sp_CLS_DeptAreaDeatailsVariationDetails',
	Error_Severity() as ErrorSeverity,
	Error_State() as ErrorState,
	GETDATE () as DateErrorRaised
END CATCH
END
GO
