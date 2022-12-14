USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSpareParts_Search]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_Search
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngSpareParts_Search  @pSparePartNo='p',@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngSpareParts_Search  @pSparePartNo=null,@pPageIndex=1,@pPageSize=5
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngSpareParts_Search]                           
  @pSparePartNo			NVARCHAR(100) =	NULL,
  @pPageIndex			INT,
  @pPageSize			INT
AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords INT
-- Default Values


-- Execution

		SELECT		@TotalRecords	=	COUNT(*)
		FROM		FMItemMaster				AS	ItemMaster		WITH(NOLOCK)
					INNER JOIN EngSpareParts	AS	SpareParts		WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					INNER JOIN FMLovMst			AS	LovPartType		WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					LEFT JOIN FMLovMst			AS	LovPartSource	WITH(NOLOCK)	ON	SpareParts.PartSourceId		=	LovPartSource.LovId
					LEFT JOIN	FMLovMst		AS	LovLocation		WITH(NOLOCK)	ON	SpareParts.Location			=	LovLocation.LovId
		WHERE		ItemMaster.Active =1
					AND SpareParts.Status=1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))

		SELECT		SpareParts.SparePartsId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue AS SparePartTypeName,
					EstimatedLifeSpanInHours,
					SpareParts.PartSourceId,
					LovPartSource.FieldValue AS PartSource,
					@TotalRecords AS TotalRecords,
					--ISNULL(SpareParts.IsExpirydate,0) AS IsExpirydate
					SpareParts.Location					AS LocationLovId,
					LovLocation.FieldValue				AS Location
		FROM		FMItemMaster				AS	ItemMaster		WITH(NOLOCK)
					INNER JOIN EngSpareParts	AS	SpareParts		WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					INNER JOIN FMLovMst			AS	LovPartType		WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					LEFT JOIN FMLovMst			AS	LovPartSource	WITH(NOLOCK)	ON	SpareParts.PartSourceId		=	LovPartSource.LovId
					LEFT JOIN	FMLovMst		AS	LovLocation		WITH(NOLOCK)	ON	SpareParts.Location			=	LovLocation.LovId
		WHERE		ItemMaster.Active =1
					AND SpareParts.Status=1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))
		ORDER BY	SpareParts.ModifiedDateUTC DESC
		OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY 



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
