USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngMwoPartReplacementTxnPopup_GetById]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngMwoPartReplacementTxn_GetById
Description			: To Get the data from table EngMaintenanceWorkOrderTxn using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngMwoPartReplacementTxnPopup_GetById] @pSparePartsId=1,@pFacilityId=1,@pPageIndex=1,@pPageSize=5,@pUserId=1

SELECT * FROM EngSpareParts
SELECT * FROM EngStockUpdateRegisterTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngMwoPartReplacementTxnPopup_GetById]                           
  @pUserId			INT	=	NULL,
  @pSparePartsId	INT,
  @pFacilityId		INT,
  @pPageIndex		INT,
  @pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @TotalRecords INT
	DECLARE	@pTotalPage		NUMERIC(24,2)

	IF(ISNULL(@pSparePartsId,0) = 0) RETURN

	SELECT	@TotalRecords	=	COUNT(*)
	FROM	EngSpareParts										AS SpareParts
			INNER JOIN  FMItemMaster							AS ItemMaster						WITH(NOLOCK)			on SpareParts.ItemId					= ItemMaster.ItemId
			INNER JOIN  EngStockUpdateRegisterTxnDet			AS StockUpdateRegisterTxnDet		WITH(NOLOCK)			on SpareParts.SparePartsId				= StockUpdateRegisterTxnDet.SparePartsId  AND StockUpdateRegisterTxnDet.FacilityId = @pFacilityId
			INNER  JOIN  FMLovMst								AS StockType						WITH(NOLOCK)			on SpareParts.SparePartType				= StockType.LovId
	WHERE	SpareParts.SparePartsId = @pSparePartsId  

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))

	SET @pTotalPage = CEILING(@pTotalPage)

	

	SELECT	SpareParts.SparePartsId								AS SparePartsId,
			StockUpdateRegisterTxnDet.StockUpdateDetId			AS StockUpdateDetId,
			StockUpdateRegisterTxnDet.CustomerId				AS CustomerId,
			StockUpdateRegisterTxnDet.FacilityId				AS FacilityId,
			SpareParts.PartNo									AS PartNo,
			SpareParts.PartDescription							AS PartDescription,
			StockUpdateRegisterTxnDet.Quantity					AS Quantity,
			StockUpdateRegisterTxnDet.Cost						AS Cost,
			StockUpdateRegisterTxnDet.InvoiceNo					AS InvoiceNo,
			StockUpdateRegisterTxnDet.VendorName				AS VendorName,
			@pTotalPage											AS TotalPageCalc
	FROM	EngSpareParts										AS SpareParts
			INNER JOIN  FMItemMaster							AS ItemMaster						WITH(NOLOCK)			on SpareParts.ItemId					= ItemMaster.ItemId
			INNER JOIN  EngStockUpdateRegisterTxnDet			AS StockUpdateRegisterTxnDet		WITH(NOLOCK)			on SpareParts.SparePartsId				= StockUpdateRegisterTxnDet.SparePartsId  AND StockUpdateRegisterTxnDet.FacilityId = @pFacilityId
			INNER  JOIN  FMLovMst								AS StockType						WITH(NOLOCK)			on SpareParts.SparePartType				= StockType.LovId
	WHERE	SpareParts.SparePartsId = @pSparePartsId 
	ORDER BY (SpareParts.PartNo) ASC
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
