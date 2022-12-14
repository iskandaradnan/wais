USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_QAPCarTxn_GetById]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_QAPCarTxn_GetById
Description			: To Get the Corrective Action Report details
Authors				: Dhilip V
Date				: 06-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_QAPCarTxn_GetById] @pCarId=51

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_QAPCarTxn_GetById]                           

  @pCarId			INT
  --@pPageIndex		INT,
  --@pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	INT

	IF(ISNULL(@pCarId,0) = 0) RETURN


    SELECT	Car.CarId,
			Car.CustomerId,
			Car.FacilityId,
			Car.ServiceId,
			Car.CARNumber,
			Car.CARDate,
			Car.CARDateUTC,
			Car.QAPIndicatorId,
			QAPInd.IndicatorCode,
			Car.AssetId,
			Asset.AssetNo,
			Asset.AssetDescription,
			Car.FromDate,
			Car.FromDateUTC,
			Car.ToDate,
			Car.ToDateUTC,
			Car.FollowupCARId,
			FollowUpCar.CARNumber			AS FollowUpCARNumber, 
			Car.ProblemStatement,
			Car.PriorityLovId,
			LovPriority.FieldValue			AS	PriorityValue,
			Car.Status,
			LovStatus.FieldValue			AS	StatusValue,
			Car.IssuerUserId,
			IssuerUserReg.StaffName			AS IssuerUserName,
			Car.CARTargetDate,
			Car.VerifiedDate,
			Car.VerifiedDateUTC,
			Car.VerifiedBy,
			VerifiedByUser.StaffName		AS VerifiedByName,
			Car.AssetTypeCodeId,
			TypeCode.AssetTypeCode,
			TypeCode.AssetTypeDescription,
			Car.ExpectedPercentage,
			Car.ActualPercentage,
			--Car.FailureSymptomId,
			--FailureSymCode.CauseCode	AS FailureSymptomCode,
			Car.[Timestamp],
			Car.[GuId],
			Car.AssignedUserId,
			AssignedUser.StaffName			AS AssignedUserName,
			Car.GuId,
			CASE	WHEN Car.IsAutoCar=1 THEN 'Auto Generation CAR'
					ELSE 'Manual CAR'
			END		AS	CARGeneration,
			Car.CARStatus					AS	CARStatus,
			LovCARStatus.FieldValue			AS	CARStatusValue,
			CarHistory.RootCause,
			CarHistory.Solution,
			CarHistory.Remarks
	FROM	QAPCarTxn						AS	Car					WITH(NOLOCK)
			INNER JOIN MstQAPIndicator		AS	QAPInd				WITH(NOLOCK) ON Car.QAPIndicatorId			=	QAPInd.QAPIndicatorId
			LEFT JOIN EngAsset				AS	Asset				WITH(NOLOCK) ON Car.AssetId					=	Asset.AssetId
			LEFT JOIN QAPCarTxn				AS	FollowUpCar			WITH(NOLOCK) ON Car.FollowupCARId			=	FollowUpCar.CarId
			LEFT JOIN FMLovMst				AS	LovPriority			WITH(NOLOCK) ON Car.PriorityLovId			=	LovPriority.LovId
			LEFT JOIN FMLovMst				AS	LovStatus			WITH(NOLOCK) ON Car.Status					=	LovStatus.LovId
			LEFT JOIN UMUserRegistration	AS	IssuerUserReg		WITH(NOLOCK) ON Car.IssuerUserId			=	IssuerUserReg.UserRegistrationId
			LEFT JOIN UMUserRegistration	AS	AssignedUser		WITH(NOLOCK) ON Car.AssignedUserId			=	AssignedUser.UserRegistrationId
			LEFT JOIN UMUserRegistration	AS	VerifiedByUser		WITH(NOLOCK) ON Car.VerifiedBy				=	VerifiedByUser.UserRegistrationId
			LEFT JOIN EngAssetTypeCode		AS	TypeCode			WITH(NOLOCK) ON Car.AssetTypeCodeId			=	TypeCode.AssetTypeCodeId
			--LEFT JOIN MstQAPQualityCause	AS	FailureSymCode		WITH(NOLOCK) ON Car.FailureSymptomId		=	FailureSymCode.QualityCauseId
			LEFT JOIN FMLovMst				AS	LovCARStatus		WITH(NOLOCK) ON Car.CARStatus				=	LovCARStatus.LovId
			LEFT JOIN QAPCarHistory			AS	CarHistory			WITH(NOLOCK) ON Car.CarId					=	CarHistory.CarId AND Car.CARStatus	=	CarHistory.Status AND Car.CARStatus=369
	WHERE	Car.CarId = @pCarId  

	/*
	SELECT	@TotalRecords	=	COUNT(*)
	FROM	QAPCarTxnDet AS CarDet
			LEFT JOIN UMUserRegistration	AS	ResponsibleUser		WITH(NOLOCK) ON CarDet.ResponsiblePersonUserId				=	ResponsibleUser.UserRegistrationId
	WHERE	CarDet.CarId = @pCarId   

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	SET @pTotalPageCalc = CEILING(@pTotalPage)
	*/

	SELECT	CarDet.CarDetId,
			CarDet.CustomerId,
			CarDet.FacilityId,
			CarDet.ServiceId,
			CarDet.CarId,
			CarDet.Activity,
			CarDet.StartDate,
			CarDet.StartDateUTC,
			CarDet.CompletedDate,
			CarDet.CompletedDateUTC,
			CarDet.ResponsiblePersonUserId,
			CarDet.TargetDate,
			CarDet.ResponsibilityId,
			ResponsibleUser.StaffName AS ResponsiblePerson,
			CarDet.ModifiedDateUTC
			--@TotalRecords					AS TotalRecords,
			--@pTotalPageCalc					AS TotalPageCalc
	FROM	QAPCarTxnDet AS CarDet
			LEFT JOIN UMUserRegistration	AS	ResponsibleUser		WITH(NOLOCK) ON CarDet.ResponsiblePersonUserId				=	ResponsibleUser.UserRegistrationId
	WHERE	CarDet.CarId = @pCarId 
	ORDER BY CarDet.CarDetId DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
END TRY

BEGIN CATCH

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   )

END CATCH
GO
