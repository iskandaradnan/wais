USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_VMSummaryFeeRpt_GetById]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_VMSummaryFeeRpt_GetById
Description			: Get the variation details for bulk authorization.
Authors				: Dhilip V
Date				: 06-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [uspFM_VMSummaryFeeRpt_GetById] @pRollOverID=10
SELECT VariationWFStatus,* FROM VmVariationTxn
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE [dbo].[uspFM_VMSummaryFeeRpt_GetById]

		@pRollOverID			INT


AS                                               

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declare
	DECLARE	@pServiceId					INT
	DECLARE	@pFacilityId				INT
	DECLARE	@pAssetClassificationId		INT
	DECLARE	@pMonth						INT
	DECLARE	@pYear						INT

	SELECT	@pServiceId=ServiceId,
			@pFacilityId=FacilityId,
			--@pAssetClassificationId=AssetClassificationId,
			@pMonth=Month,
			@pYear=Year
	FROM VMRollOverFeeReport WHERE RollOverFeeId	=	@pRollOverID

	SELECT	RollOverFeeId,
			ServiceId,
			FacilityId,
			--NULLIF(AssetClassificationId,'') AS AssetClassificationId,
			Month,
			Year
	FROM VMRollOverFeeReport WHERE RollOverFeeId	=	@pRollOverID

EXEC [uspFM_VMSummaryFeeRpt_Fetch] @pServiceId=@pServiceId,@pFacilityId=@pFacilityId,--@pAssetClassificationId=@pAssetClassificationId,
@pMonth=@pMonth,@pYear=@pYear,@pRollOverID=@pRollOverID

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
