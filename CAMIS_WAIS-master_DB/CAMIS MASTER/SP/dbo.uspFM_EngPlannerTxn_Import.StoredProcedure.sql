USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPlannerTxn_Import]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxn_Import
Description			: If Stock Update already exists then update else insert.
Authors				: Balaji M S
Date				: 05-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC [uspFM_EngPlannerTxn_Import] @pPlannerId=null,@pWorkOrderType='Warranty PPM',@pAssignee='Super Admin',@pAssetClassification='General',@pAssetNo='SampleTest',@pPPMTaskCode='TypeCode1-000002'
,@pTypeCode= "ATC-General/01",@pPPMType='Warranty',@pSchedule='Monthly-Day',@pStatus='Active'
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE  PROCEDURE  [dbo].[uspFM_EngPlannerTxn_Import]
	
			
			@pPlannerId						INT	= NULL,
			@pWorkOrderType					NVARCHAR(200)   = NULL,
			@pAssignee						NVARCHAR(1000)  = NULL,
			@pAssetClassification			NVARCHAR(1000)  = NULL,
			@pAssetNo						NVARCHAR(1000)  = NULL,
			@pPPMTaskCode					NVARCHAR(1000)  = NULL,
			@pTypeCode						NVARCHAR(1000)  = NULL,
			@pPPMType						NVARCHAR(1000)  = NULL,
			@pSchedule						NVARCHAR(1000)  = NULL,
			@pStatus						NVARCHAR(1000)  = NULL,
			@pTaskCodeOption				NVARCHAR(1000)  = NULL

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @mWorkOrderTypeId			INT,
			@mAssigneeId				INT,
			@mAssetClassificationId		INT,
			@mAssetId					INT,
			@mTaskCodeId				INT,
			@mAssetTypeCodeId			INT,
			@mPPMTypeId					INT,
			@mScheduleId				INT,
			@mStatusId					INT,
			@mErrorMessage	NVARCHAR(500) ='',
			@mTaskCodeOptionId			INT,
			@mLenErrorMsg				INT
			
-- Default Values


-- Execution


	SET @mWorkOrderTypeId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pWorkOrderType)) AND LovKey='WorkOrderTypeValue')
	SET @mTaskCodeOptionId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pTaskCodeOption))  and lovkey='PlannerScheduleTypeValue')

	SET @mAssigneeId = (SELECT UserRegistrationId FROM UMUserRegistration WHERE LTRIM(RTRIM(StaffName))	=	LTRIM(RTRIM(@pAssignee)))

	SET @mAssetClassificationId = (SELECT AssetClassificationId FROM EngAssetClassification WHERE LTRIM(RTRIM(AssetClassificationDescription))	=	LTRIM(RTRIM(@pAssetClassification)))

	
	IF (@pTypeCode IS NOT NULL)
	BEGIN
	SET @mAssetTypeCodeId = (SELECT AssetTypeCodeId FROM EngAssetTypeCode WHERE LTRIM(RTRIM(AssetTypeCode))	=	LTRIM(RTRIM(@pTypeCode)) AND AssetClassificationId = @mAssetClassificationId)
	END


	IF(@pTypeCode IS NOT NULL AND @mAssetTypeCodeId IS NOT NULL)
	BEGIN
	SET @mAssetId = (SELECT AssetId FROM EngAsset WHERE LTRIM(RTRIM(AssetNo))	=	LTRIM(RTRIM(@pAssetNo)) AND AssetClassification = @mAssetClassificationId AND
	AssetTypeCodeId = @mAssetTypeCodeId)
	END 

	IF(@pTypeCode IS NULL )
	BEGIN
	SET @mAssetId = (SELECT AssetId FROM EngAsset WHERE LTRIM(RTRIM(AssetNo))	=	LTRIM(RTRIM(@pAssetNo)) AND AssetClassification = @mAssetClassificationId)
	END 


	--SET @mTaskCodeId = (SELECT PPMId FROM EngPPMRegisterMst WHERE LTRIM(RTRIM(BemsTaskCode))	=	LTRIM(RTRIM(@pPPMTaskCode)))
	SET @mTaskCodeId = (SELECT PPMCheckListId FROM EngAssetPPMCheckList WHERE LTRIM(RTRIM(TaskCode))	=	LTRIM(RTRIM(@pPPMTaskCode)))


	SET @mPPMTypeId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pPPMType)) AND LovKey='WarrantyTypeValue')

	SET @mScheduleId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pSchedule)) AND LovKey='ScheduleTypeValue')

	SET @mStatusId = (SELECT LovId FROM FMLovMst WHERE LTRIM(RTRIM(FieldValue))	=	LTRIM(RTRIM(@pStatus)) AND LovKey='StatusValue')

	IF (ISNULL(@mWorkOrderTypeId,0)=0)
		BEGIN
			SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Work Order Type' ErrorMessage)

		END
	
	IF (ISNULL(@mAssigneeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Assignee Name' ErrorMessage)
	END

	IF (ISNULL(@mAssetClassificationId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Classification' ErrorMessage)
	END

	IF (ISNULL(@mAssetTypeCodeId,0)=0 AND @pTypeCode IS NOT NULL)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset Type Code' ErrorMessage)
	END

	IF (ISNULL(@mAssetId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Asset No' ErrorMessage)
	END

	IF (ISNULL(@mTaskCodeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Task Code' ErrorMessage)
	END

	IF (ISNULL(@mPPMTypeId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild PPM Type' ErrorMessage)
	END
	IF (ISNULL(@mTaskCodeOptionId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Task Code Option' ErrorMessage)
	END
	
	IF (ISNULL(@mTaskCodeOptionId,0) = 364 and      isnull(@mScheduleId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Schedule' ErrorMessage)
	END

	IF (ISNULL(@mStatusId,0)=0)
	BEGIN
		SET @mErrorMessage = @mErrorMessage + ' , ' + (SELECT 'Please enter vaild Status' ErrorMessage)
	END


	SET @mLenErrorMsg = LEN(@mErrorMessage)

			SELECT	 
			@mWorkOrderTypeId					AS WorkOrderTypeId,
			@mAssigneeId						AS AssigneeId,
			@mAssetClassificationId				AS AssetClassificationId,
			@mAssetId							AS AssetId,
			@mTaskCodeId						AS TaskCodeId,
			@mAssetTypeCodeId					AS AssetTypeCodeId,
			@mPPMTypeId							AS PPMTypeId,
			@mScheduleId						AS ScheduleId,
			@mStatusId							AS StatusId,
			@mTaskCodeOptionId					AS TaskCodeOptionId,
			SUBSTRING(@mErrorMessage,3,@mLenErrorMsg)						AS ErrorMessage


	
		IF @mTRANSCOUNT = 0
	        BEGIN
	            COMMIT TRANSACTION
	        END   
	

END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
