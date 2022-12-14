USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngSparePartsStock_Fetch]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngSparePartsStock_Fetch
Description			: SpareParts search popup
Authors				: Dhilip V
Date				: 25-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngSparePartsStock_Fetch  @pSparePartNo='p',@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngSparePartsStock_Fetch  @pSparePartNo=null,@pPageIndex=1,@pPageSize=5
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngSparePartsStock_Fetch]                           
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
		--FROM		FMItemMaster ItemMaster							WITH(NOLOCK)
		--			INNER JOIN EngSpareParts SpareParts				WITH(NOLOCK)	ON	ItemMaster.ItemId	=	SpareParts.ItemId
		--			INNER JOIN FMLovMst LovPartType					WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
		--			INNER JOIN EngStockUpdateRegisterTxnDet UpdateRegisterDet		WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	UpdateRegisterDet.SparePartsId
		--WHERE		ItemMaster.Active =1
		--			AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))

		SELECT		
					--SpareParts.SparePartsId,
					--UpdateRegisterDet.StockUpdateDetId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue					AS SparePartTypeName,
					SUM(UpdateRegisterDet.Quantity)			AS Quantity,
					SUM(UpdateRegisterDet.Cost)				AS	Cost,
					SUM(UpdateRegisterDet.PurchaseCost)		AS	PurchaseCost,
					--UpdateRegisterDet.InvoiceNo,
					--UpdateRegisterDet.VendorName,
					--STUFF(UpdateRegisterDet.InvoiceNo,1,1,UpdateRegisterDet.InvoiceNo) InvoiceNo,
					InvoiceNoSub.InvoiceNo,
					InvoiceNoSub.VendorName,
					@TotalRecords AS TotalRecords
		FROM		FMItemMaster ItemMaster WITH(NOLOCK)
					INNER JOIN EngSpareParts SpareParts								WITH(NOLOCK)	ON	ItemMaster.ItemId			=	SpareParts.ItemId
					INNER JOIN FMLovMst LovPartType									WITH(NOLOCK)	ON	SpareParts.SparePartType	=	LovPartType.LovId
					INNER JOIN EngStockUpdateRegisterTxnDet UpdateRegisterDet		WITH(NOLOCK)	ON	SpareParts.SparePartsId		=	UpdateRegisterDet.SparePartsId
					CROSS APPLY
					(
					SELECT 
					Stuff(
					        (
					            SELECT DISTINCT N', ' + UpdateRegisterDet1.InvoiceNo 
							FROM		EngStockUpdateRegisterTxnDet UpdateRegisterDet1		WITH(NOLOCK)
							WHERE	UpdateRegisterDet1.SparePartsId		=	SpareParts.SparePartsId	
							FOR XML PATH(''),TYPE
					        )
					    .value('text()[1]','nvarchar(max)'),1,2,N''
					    ) AS InvoiceNo,
					Stuff(
					        (
					            SELECT DISTINCT N', ' + UpdateRegisterDet1.VendorName 
							FROM		EngStockUpdateRegisterTxnDet UpdateRegisterDet1		WITH(NOLOCK)
							WHERE	UpdateRegisterDet1.SparePartsId		=	SpareParts.SparePartsId	
							FOR XML PATH(''),TYPE
					        )
					    .value('text()[1]','nvarchar(max)'),1,2,N''
					    ) AS VendorName
					) AS InvoiceNoSub

		WHERE		ItemMaster.Active =1
					AND ((ISNULL(@pSparePartNo,'') = '' )	OR (ISNULL(@pSparePartNo,'') <> '' AND SpareParts.PartNo LIKE + '%' + @pSparePartNo + '%' ))
		GROUP BY	SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemId,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					SpareParts.SparePartType,
					LovPartType.FieldValue,
					InvoiceNoSub.InvoiceNo,
					InvoiceNoSub.VendorName
		ORDER BY	SpareParts.PartNo DESC
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
