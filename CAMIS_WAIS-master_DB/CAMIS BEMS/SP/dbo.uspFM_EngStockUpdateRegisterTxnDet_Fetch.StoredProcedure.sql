USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockUpdateRegisterTxnDet_Fetch]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockUpdateRegisterTxnDet_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 25-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngStockUpdateRegisterTxnDet_Fetch  @pSparePartNo='p',@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngStockUpdateRegisterTxnDet_Fetch  @pSparePartNo='',@pPageIndex=1,@pPageSize=50,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[uspFM_EngStockUpdateRegisterTxnDet_Fetch]                           
  @pSparePartNo			NVARCHAR(100) =	NULL,
  @pPageIndex			INT,
  @pPageSize			INT,
  @pFacilityId			INT
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
		FROM		FMItemMaster							AS	ItemMaster			WITH(NOLOCK)
					INNER JOIN EngSpareParts				AS	SpareParts			WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					INNER JOIN FMLovMst						AS	LovPartType			WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					INNER JOIN EngStockUpdateRegisterTxnDet AS	UpdateRegisterDet	WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	UpdateRegisterDet.SparePartsId
		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND (SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' OR UpdateRegisterDet.InvoiceNo LIKE  + '%' + @pSparePartNo + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UpdateRegisterDet.FacilityId = @pFacilityId))
					AND UpdateRegisterDet.SparePartsId NOT IN (	SELECT DISTINCT ISNULL(StockAdjDet.SparePartsId,0)
																FROM	EngStockAdjustmentTxnDet AS StockAdjDet WITH(NOLOCK)
																		INNER JOIN EngStockAdjustmentTxn AS StockAdj WITH(NOLOCK) ON StockAdjDet.StockAdjustmentId=StockAdj.StockAdjustmentId
																WHERE  UpdateRegisterDet.SparePartsId=StockAdjDet.SparePartsId	
																AND UpdateRegisterDet.InvoiceNo=StockAdjDet.InvoiceNo
																--AND DATEDIFF(DD,StockAdj.AdjustmentDate,GETDATE())<2
																--GROUP BY	CAST(StockAdj.AdjustmentDate AS DATE)
																--HAVING COUNT(CAST(StockAdj.AdjustmentDate AS DATE))>=1
					)


		SELECT		SpareParts.SparePartsId,
					UpdateRegisterDet.StockUpdateDetId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue AS SparePartTypeName,
					UpdateRegisterDet.Quantity,
					UpdateRegisterDet.Cost,
					UpdateRegisterDet.PurchaseCost,
					UpdateRegisterDet.InvoiceNo,
					UpdateRegisterDet.VendorName,
					SpareParts.EstimatedLifeSpanInHours,
					@TotalRecords AS TotalRecords,
					UpdateRegisterDet.BinNo
		FROM		FMItemMaster							AS	ItemMaster			WITH(NOLOCK)
					INNER JOIN EngSpareParts				AS	SpareParts			WITH(NOLOCK)	ON	ItemMaster.ItemId				=	SpareParts.ItemId
					INNER JOIN EngStockUpdateRegisterTxnDet AS	UpdateRegisterDet	WITH(NOLOCK)	ON	SpareParts.SparePartsId			=	UpdateRegisterDet.SparePartsId
					INNER JOIN FMLovMst						AS	LovPartType			WITH(NOLOCK)	ON	UpdateRegisterDet.SparePartType	=	LovPartType.LovId
					
		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND (SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' OR UpdateRegisterDet.InvoiceNo LIKE  + '%' + @pSparePartNo + '%') ))
					AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UpdateRegisterDet.FacilityId = @pFacilityId))
					AND UpdateRegisterDet.SparePartsId NOT IN (	SELECT DISTINCT ISNULL(StockAdjDet.SparePartsId,0)
																FROM	EngStockAdjustmentTxnDet AS StockAdjDet WITH(NOLOCK)
																		INNER JOIN EngStockAdjustmentTxn AS StockAdj WITH(NOLOCK) ON StockAdjDet.StockAdjustmentId=StockAdj.StockAdjustmentId
																WHERE  UpdateRegisterDet.SparePartsId=StockAdjDet.SparePartsId	
																AND UpdateRegisterDet.InvoiceNo=StockAdjDet.InvoiceNo
																--AND DATEDIFF(DD,StockAdj.AdjustmentDate,GETDATE())<2
																--GROUP BY	CAST(StockAdj.AdjustmentDate AS DATE)
																--HAVING COUNT(CAST(StockAdj.AdjustmentDate AS DATE))>=1
					)
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
		   );
		THROW;

END CATCH
GO
