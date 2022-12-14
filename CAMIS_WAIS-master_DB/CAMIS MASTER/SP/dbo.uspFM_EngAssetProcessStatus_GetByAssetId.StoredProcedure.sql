USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngAssetProcessStatus_GetByAssetId]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngAssetProcessStatus_GetByAssetId
Description			: Get the staff details by passing the staffId.
Authors				: Dhilip V
Date				: 02-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngAssetProcessStatus_GetByAssetId  @pAssetId=87,@pPageIndex=1,@pPageSize=5

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngAssetProcessStatus_GetByAssetId]                           
  @pAssetId			INT,
  @pPageIndex		INT	=	NULL,
  @pPageSize		INT	=	NULL
AS                                                     

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution


	IF(ISNULL(@pAssetId,0) = 0) RETURN

    SELECT	DISTINCT Asset.CustomerId				AS	CustomerId,	
			Asset.FacilityId				AS	FacilityId,
			BER.BERno						AS	BERDocumentNo,
			'BER'							AS	ProcessName,
			CAST(BER.ModifiedDate	AS DATE)				AS	DateDone,
			--format(BER.ModifiedDate,'dd-MMM-yyyy')				AS	DateDone,
			BER.BERStatus					AS	ProcessStatusLovId,
			LovProcessStatus.FieldValue		AS	ProcessStatusLovName
 	FROM	EngAsset						AS	Asset				WITH(NOLOCK)			
			INNER JOIN	BERApplicationTxn	AS	BER					WITH(NOLOCK)	ON Asset.AssetId		=	BER.AssetId
			INNER JOIN	FMLovMst			AS	LovProcessStatus	WITH(NOLOCK)	ON BER.BERStatus		=	LovProcessStatus.LovId
			LEFT JOIN	BERApplicationHistoryTxn	AS	BERHistory	WITH(NOLOCK)	ON BER.ApplicationId	=	BERHistory.ApplicationId
	WHERE	BER.AssetId	=	@pAssetId
			AND BERStatus <> 202
UNION

    SELECT	DISTINCT Asset.CustomerId						AS	CustomerId,	
			Asset.FacilityId						AS	FacilityId,
			BER.BERno								AS	BERDocumentNo,
			'BER'									AS	ProcessName,
			CAST(BERHistory.CreatedDate	AS DATE)					AS	DateDone,
			--format(BERHistory.CreatedDate,'dd-MMM-yyyy')				AS	DateDone,
			BERHistory.Status						AS	ProcessStatusLovId,
			LovProcessStatus.FieldValue				AS	ProcessStatusLovName
 	FROM	EngAsset								AS	Asset				WITH(NOLOCK)			
			INNER JOIN	BERApplicationTxn			AS	BER					WITH(NOLOCK)	ON Asset.AssetId		=	BER.AssetId
			INNER JOIN	BERApplicationHistoryTxn	AS	BERHistory			WITH(NOLOCK)	ON BER.ApplicationId	=	BERHistory.ApplicationId
			INNER JOIN	FMLovMst					AS	LovProcessStatus	WITH(NOLOCK)	ON BERHistory.Status	=	LovProcessStatus.LovId
	WHERE	BER.AssetId	=	@pAssetId
			AND BERHistory.Status <> 202
	--ORDER BY	BER.AssetId ASC,BERHistory.ModifiedDate DESC
	--OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 
UNION
    SELECT	DISTINCT Asset.CustomerId						AS	CustomerId,	
			Asset.FacilityId						AS	FacilityId,
			CRMWO.CRMWorkOrderNo					AS	CRMWorkOrderNo,
			'CRM'									AS	ProcessName,
			CAST(ProcessStatus.DoneDate	AS DATE)				AS	DateDone,
			--format(ProcessStatus.DoneDate,'dd-MMM-yyyy')				AS	DateDone,
			ProcessStatus.Status					AS	ProcessStatusLovId,
			CASE	WHEN ProcessStatus.Status IN (139) THEN 'Recall Raised'
					WHEN ProcessStatus.Status IN (142) THEN 'Recall Closed' 
			END	AS	ProcessStatusLovName
 	FROM	EngAsset								AS	Asset				WITH(NOLOCK)			
			INNER JOIN	CRMRequestWorkOrderTxn		AS	CRMWO				WITH(NOLOCK)	ON Asset.AssetId		=	CRMWO.AssetId
			INNER JOIN	CRMRequestProcessStatus		AS	ProcessStatus		WITH(NOLOCK)	ON CRMWO.CRMRequestWOId	=	ProcessStatus.CRMRequestWOId
			INNER JOIN	FMLovMst					AS	LovProcessStatus	WITH(NOLOCK)	ON ProcessStatus.Status	=	LovProcessStatus.LovId
	WHERE	CRMWO.AssetId	=	@pAssetId
			AND CRMWO.TypeOfRequest = 136
			AND ProcessStatus.Status IN (139,142)
	--ORDER BY	BER.AssetId ASC,BERHistory.ModifiedDate DESC

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
