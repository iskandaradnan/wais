USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetTypeCode_Search]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: [uspFM_EngAssetTypeCode_Search]
Description			: Asset Type Code Search popup
Authors				: Dhilip V
Date				: 07-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_EngAssetTypeCode_Search]  @pPageIndex=1,@pPageSize=5,@pAssetClassification='', @pAssetClassificationId=NULL,@pTypeCode=null,@pTypeCodeDescription=null
EXEC [uspFM_EngAssetTypeCode_Search]  @pAssetClassification='', @pAssetClassificationId=NULL,@pTypeCode=null,@pTypeCodeDescription=null,@pPageIndex=1,@pPageSize=5,@ScreenName='StandardTaskDetails'
EXEC [uspFM_EngAssetTypeCode_Search]  @pAssetClassification='', @pAssetClassificationId=NULL,@pTypeCode=null,@pTypeCodeDescription=null,@pPageIndex=1,@pPageSize=20
,@ScreenName='StandardTaskDetails',@pPlannerFlag=NULL,@pCheckEquipmentFunctionDescription=1,@pFacilityId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngAssetTypeCode_Search]                           
                            
  @pAssetClassification			NVARCHAR(100)	=	NULL,
  @pAssetClassificationDescr	NVARCHAR(100)	=	NULL,
  @pAssetClassificationId		INT				=	NULL,
  @pTypeCode					NVARCHAR(100)	=	NULL,
  @pTypeCodeDescription			NVARCHAR(100)	=	NULL,
  @pPageIndex					INT,
  @pPageSize					INT, 
  @ScreenName					NVARCHAR(200)	= NULL,
  @pPlannerFlag					NVARCHAR(200)= NULL,
  @pCheckEquipmentFunctionDescription INT = NULL,
  @pFacilityId	INT = NULL,
  @pServiceId	INT = NULL

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT

-- Default Values


-- Execution

IF(@pCheckEquipmentFunctionDescription <> 1 OR @pCheckEquipmentFunctionDescription IS NULL)

BEGIN

	 IF(ISNULL(@pPlannerFlag,'')='' or ISNULL(@pPlannerFlag,0)=0)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCode
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationId,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									--AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1 and AssetTypeCode.ServiceId=@pServiceId
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId)
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						)
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCode

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCode
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	ELSE IF(@pPlannerFlag = 34)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodePPM
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									----AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1
									AND CodeFlag.MaintenanceFlag	=	94
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodePPM

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId
					AssetClassificationCode,
					AssetClassificationDescription
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodePPM
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	ELSE IF(@pPlannerFlag = 35)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodeRI
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									----AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1
									AND CodeFlag.MaintenanceFlag	=	95
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodeRI

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodeRI
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END


	 ELSE IF(@pPlannerFlag=36 OR @pPlannerFlag=198)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodeOthers
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									--AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1
									AND CodeFlag.MaintenanceFlag	IN (96,97,98)
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodeOthers

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodeOthers
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

END


--------------------------------------------------------------------------------------------------------------------------------------------
ELSE

BEGIN

DECLARE @TypeofNomenclature INT

SET @TypeofNomenclature = (SELECT TypeofNomenclature FROM MstLocationFacility WHERE FacilityId = @pFacilityId) 



	 IF(ISNULL(@pPlannerFlag,'')='' or ISNULL(@pPlannerFlag,0)=0)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCode1
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationId,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									--AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1 AND EquipmentFunctionCatagoryLovId = @TypeofNomenclature
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCode1

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCode1
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	ELSE IF(@pPlannerFlag = 34)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodePPM1
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									----AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1 AND EquipmentFunctionCatagoryLovId = @TypeofNomenclature
									AND CodeFlag.MaintenanceFlag	=	94
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodePPM1

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId
					AssetClassificationCode,
					AssetClassificationDescription
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodePPM1
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

	ELSE IF(@pPlannerFlag = 35)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodeRI1
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									----AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1 AND EquipmentFunctionCatagoryLovId = @TypeofNomenclature
									AND CodeFlag.MaintenanceFlag	=	95
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodeRI1

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodeRI1
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END


	 ELSE IF(@pPlannerFlag=36 OR @pPlannerFlag=198)
		BEGIN

			SELECT	Sub.AssetTypeCodeId,
					Sub.AssetTypeCode,
					Sub.AssetTypeDescription,
					Sub.AssetClassificationCode,
					Sub.AssetClassificationId,
					Sub.AssetClassificationDescription,
					--MAX(Sub.ExpectedLifeSpan)	AS ExpectedLifeSpan,
					--Sub.RiskRating,
					MAX(PPM)					AS PPM,
					MAX(RI)						AS RI,
					MAX(Other)					AS Other,
					MAX(Sub.TotalRecords)		AS TotalRecords,
					MAX(ModifiedDateUTC)		AS ModifiedDateUTC	
					INTO #ResultAssetTypeCodeOthers1
			FROM	(
						SELECT		AssetTypeCode.AssetTypeCodeId,
									AssetTypeCode.AssetTypeCode,
									AssetTypeCode.AssetTypeDescription,
									AssetClassification.AssetClassificationCode,
									AssetClassification.AssetClassificationDescription,
									--AssetTypeCode.ExpectedLifeSpan,
									--AssetTypeCode.RiskRatingLovId,
									--LovRiskRating.FieldValue										AS RiskRating,
									AssetTypeCode.AssetClassificationId,
									CASE WHEN PPM.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS PPM,
									CASE WHEN RI.FieldValue IS NOT NULL THEN 1 ELSE 0 END			AS RI,
									CASE WHEN Calibration.FieldValue IS NOT NULL THEN 1 ELSE 0 END	AS Other,
									AssetTypeCode.ModifiedDateUTC,
									@TotalRecords AS TotalRecords
						FROM		EngAssetTypeCode					AS AssetTypeCode		WITH(NOLOCK)
									INNER JOIN	EngAssetClassification  AS AssetClassification 	WITH(NOLOCK)	ON 	AssetTypeCode.AssetClassificationId = AssetClassification.AssetClassificationId
									INNER JOIN 	EngAssetTypeCodeFlag	AS CodeFlag				WITH(NOLOCK)	ON AssetTypeCode.AssetTypeCodeId	=	CodeFlag.AssetTypeCodeId
									--LEFT JOIN 	FMLovMst	AS LovRiskRating					WITH(NOLOCK)	ON AssetTypeCode.RiskRatingLovId	=	LovRiskRating.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 94) PPM on CodeFlag.MaintenanceFlag= PPM.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 95) RI on CodeFlag.MaintenanceFlag= RI.LovId
									LEFT JOIN (select * from FMLovMst where LovId = 96) Calibration on CodeFlag.MaintenanceFlag= Calibration.LovId
						WHERE		AssetTypeCode.Active =1 AND EquipmentFunctionCatagoryLovId = @TypeofNomenclature
									AND CodeFlag.MaintenanceFlag	IN (96,97,98)
						--ORDER BY	AssetTypeCode.ModifiedDateUTC DESC
						--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
					) Sub
			WHERE   ((ISNULL(@pTypeCode,'')='' )	OR ( ISNULL(@pTypeCode,'') <> ''  AND Sub.AssetTypeCode LIKE '%' + @pTypeCode + '%'))
						AND ((ISNULL(@pTypeCodeDescription,'')='' ) OR (ISNULL(@pTypeCodeDescription ,'') <> '' AND Sub.AssetTypeDescription LIKE '%' + @pTypeCodeDescription + '%'))
						AND ((ISNULL(@pAssetClassification,'')='' ) OR (ISNULL(@pAssetClassification,'') <> '' AND Sub.AssetClassificationCode LIKE '%' + @pAssetClassification + '%'))
						AND ((ISNULL(@pAssetClassificationDescr,'')='' ) OR (ISNULL(@pAssetClassificationDescr,'') <> '' AND Sub.AssetClassificationDescription LIKE '%' + @pAssetClassificationDescr + '%'))
						AND ((ISNULL(@pAssetClassificationId,'')='' )	OR ( ISNULL(@pAssetClassificationId,'') <> ''  AND Sub.AssetClassificationId =  @pAssetClassificationId))
			GROUP BY Sub.AssetTypeCodeId,AssetTypeCode,Sub.AssetTypeDescription,Sub.AssetClassificationCode,Sub.AssetClassificationCode,Sub.AssetClassificationId,Sub.AssetClassificationDescription
			
			SELECT @TotalRecords	=	COUNT(*) FROM #ResultAssetTypeCodeOthers1

			SELECT	AssetTypeCodeId,
					AssetTypeCode,
					AssetTypeDescription,
					AssetClassificationId,
					AssetClassificationCode,
					AssetClassificationDescription,
					--ExpectedLifeSpan,
					--RiskRating,
					PPM ,
					RI,
					Other,
					@TotalRecords		AS	TotalRecords
			FROM #ResultAssetTypeCodeOthers1
			ORDER BY ModifiedDateUTC DESC
			OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY
		END

END

END TRY

BEGIN CATCH

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
