USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSpareParts_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSpareParts_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 04-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngSpareParts_Fetch  @pSparePartNo='sp',@pPageIndex=1,@pPageSize=50
EXEC uspFM_EngSpareParts_Fetch  @pSparePartNo=null,@pPageIndex=1,@pPageSize=5
select * from EngSpareParts
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngSpareParts_Fetch]                           
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

		--SELECT		@TotalRecords	=	COUNT(*)
		--FROM		FMItemMaster ItemMaster WITH(NOLOCK)
		--			INNER JOIN EngSpareParts SpareParts							WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
		--			INNER JOIN EngStockUpdateRegisterTxnDet StockUpdateRegister WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	StockUpdateRegister.SparePartsId
		--			INNER JOIN FMLovMst LovPartType								WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
		--			LEFT JOIN FMLovMst LovPartSource							WITH(NOLOCK)	ON	SpareParts.PartSourceId	=	LovPartSource.LovId
		--			LEFT JOIN FMLovMst LifeSpanOption							WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId	=	LifeSpanOption.LovId
		--			LEFT JOIN	FMLovMst					AS	LovLocation		WITH(NOLOCK)	ON SpareParts.Location			=	LovLocation.LovId
		--WHERE		ItemMaster.Active =1
		--			AND SpareParts.Status=1
		--			AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))

		SELECT		DISTINCT SpareParts.SparePartsId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue AS SparePartTypeName,
					SpareParts.PartSourceId,
					LovPartSource.FieldValue AS PartSource,
					
					SpareParts.LifeSpanOptionId,
					LifeSpanOption.FieldValue as LifeSpanOptionValue,
					StockUpdateRegister.EstimatedLifeSpan as EstimatedLifeSpanInHours,
					MAX(StockUpdateRegister.StockExpiryDate) AS StockExpiryDate,
					SpareParts.Location					AS LocationLovId,
					LovLocation.FieldValue				AS Location
					--ISNULL(SpareParts.IsExpirydate,0) AS IsExpirydate
		INTO #ResSet
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
					INNER JOIN EngSpareParts SpareParts							WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					LEFT JOIN EngStockUpdateRegisterTxnDet StockUpdateRegister WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	StockUpdateRegister.SparePartsId
					INNER JOIN FMLovMst LovPartType								WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					LEFT JOIN FMLovMst LovPartSource							WITH(NOLOCK)	ON	SpareParts.PartSourceId	=	LovPartSource.LovId
					LEFT JOIN FMLovMst LifeSpanOption							WITH(NOLOCK)	ON	SpareParts.LifeSpanOptionId	=	LifeSpanOption.LovId
					LEFT JOIN	FMLovMst					AS	LovLocation		WITH(NOLOCK)	ON SpareParts.Location			=	LovLocation.LovId
		WHERE		ItemMaster.Active =1
					AND SpareParts.Status=1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))
		GROUP BY SpareParts.SparePartsId,SpareParts.PartNo,SpareParts.PartDescription,ItemMaster.ItemId,ItemMaster.ItemNo,
					ItemMaster.ItemDescription,SpareParts.SparePartType,LovPartType.FieldValue,SpareParts.PartSourceId,LovPartSource.FieldValue,
					SpareParts.LifeSpanOptionId,LifeSpanOption.FieldValue,StockUpdateRegister.EstimatedLifeSpan,SpareParts.Location,LovLocation.FieldValue

		SELECT		@TotalRecords	=	COUNT(*)
		FROM	#ResSet

		SELECT * ,@TotalRecords AS TotalRecords
		FROM #ResSet
		ORDER BY	SparePartsId DESC
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
