USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSparesStockUpdatePopup_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSparesStockUpdatePopup_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 04-June-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngSparesStockUpdatePopup_Fetch  @pSparePartNo='p',@pSparePartsId=1,@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngSparesStockUpdatePopup_Fetch  @pSparePartNo=null,@pSparePartsId=1,@pFacilityId=1
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngSparesStockUpdatePopup_Fetch]                           
  @pSparePartNo			NVARCHAR(100) =	NULL,
  @pSparePartsId		INT	=	NULL--,
 -- @pFacilityId			INT
  --@pPageIndex			INT,
  --@pPageSize			INT
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
		--FROM		FMItemMaster ItemMaster							WITH(NOLOCK)
		--			INNER JOIN EngSpareParts SpareParts				WITH(NOLOCK)	ON	ItemMaster.ItemId	=	SpareParts.ItemId
		--			INNER JOIN FMLovMst LovPartType					WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
		--			INNER JOIN EngStockUpdateRegisterTxnDet UpdateRegisterDet		WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	UpdateRegisterDet.SparePartsId
		--WHERE		ItemMaster.Active =1
		--			AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))
		--			AND ((ISNULL(@pSparePartsId,'') = '' )	OR (ISNULL(@pSparePartsId,'') <> '' AND SpareParts.SparePartsId = @pSparePartsId  ))

		SELECT		SpareParts.SparePartsId,
					UpdateRegisterDet.StockUpdateDetId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue AS SparePartTypeName,
					--UpdateRegisterDet.Quantity,
					case when (isnull(UpdateRegisterDet.Quantity,0) - isnull((select count(Quantity) from EngMwoPartReplacementTxn a where a.StockUpdateDetId=UpdateRegisterDet.StockUpdateDetId ),0) )<0 
						 then 0 else  isnull(UpdateRegisterDet.Quantity,0) - isnull((select count(Quantity) from EngMwoPartReplacementTxn a where a.StockUpdateDetId=UpdateRegisterDet.StockUpdateDetId ),0) end 
						 Quantity,
					UpdateRegisterDet.Cost,
					UpdateRegisterDet.PurchaseCost,
					UpdateRegisterDet.InvoiceNo,
					UpdateRegisterDet.VendorName,
					Referred.IsReferred
					--@TotalRecords AS TotalRecords
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
					INNER JOIN EngSpareParts SpareParts								WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					Left JOIN FMLovMst LovPartType									WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					INNER JOIN EngStockUpdateRegisterTxnDet UpdateRegisterDet		WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	UpdateRegisterDet.SparePartsId
					OUTER APPLY 
						(	SELECT CASE WHEN ISNULL(COUNT(Det.SparePartsId),0)>0 THEN 1
										ELSE 0 END IsReferred
							FROM EngStockUpdateRegisterTxnDet AS Det	WITH(NOLOCK)
							WHERE ISNULL(UpdateRegisterDet.StockUpdateDetId,'')	=	ISNULL(Det.StockUpdateDetId,0)
						) Referred
								
		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))
					AND ((ISNULL(@pSparePartsId,'') = '' )	OR (ISNULL(@pSparePartsId,'') <> '' AND SpareParts.SparePartsId = @pSparePartsId  ))
					--AND ((ISNULL(@pFacilityId,'')='' )		OR (ISNULL(@pFacilityId,'') <> '' AND UpdateRegisterDet.FacilityId = @pFacilityId))
		ORDER BY	SpareParts.ModifiedDateUTC DESC
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
