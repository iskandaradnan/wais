USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngStockMonthlyRegisterTxnDetPopup_GetById]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: UspFM_EngStockMonthlyRegisterTxnDet_GetById
Description			: To Get the data from table EngStockMonthlyRegisterTxnDet using the Primary Key id
Authors				: Balaji M S
Date				: 30-Mar-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC [UspFM_EngStockMonthlyRegisterTxnDetPopup_GetById] @pSparePartsId=41,@pYear=2018,@pMonth=8,@pUserId=1,@pBinNo=NULL

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
CREATE PROCEDURE  [dbo].[UspFM_EngStockMonthlyRegisterTxnDetPopup_GetById]                           
  @pUserId			INT	=	NULL,
  @pSparePartsId	INT,
  @pYear			INT,
  @pMonth			INT,
  @pBinNo			NVARCHAR(100) = NULL
  --@pPageIndex		INT,
  --@pPageSize		INT	

AS                                              

BEGIN TRY



	SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	  @TotalRecords		INT
	DECLARE   @pTotalPage		NUMERIC(24,2)
	DECLARE   @pTotalPageCalc	NUMERIC(24,2)
	DECLARE	  @MonthStartDate	DATE
	DECLARE	  @MonthEndDate		DATE

	set @MonthStartDate = DATEFROMPARTS(@pYear,@pMonth,1)
	set @MonthEndDate	= EOMONTH (DATEFROMPARTS(@pYear,@pMonth,1))

	IF(ISNULL(@pSparePartsId,0) = 0) RETURN




		


    SELECT		distinct	SpareParts.SparePartsId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					--StockUpdateDet.Quantity,
					isnull(ISNULL(StockAdj.PhysicalQuantity,StockUpdateDet.Quantity),0)-isnull(rep.replaceQuantity,0)as Quantity,
					StockUpdateDet.Cost,
					StockUpdateDet.PurchaseCost,
					StockUpdateDet.InvoiceNo,
					StockUpdateDet.VendorName
		FROM		EngStockUpdateRegisterTxn				AS	StockUpdate			WITH(NOLOCK)	
					INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUpdateDet		WITH(NOLOCK)	ON  StockUpdate.StockUpdateId		= StockUpdateDet.StockUpdateId
					outer apply (select top 1 StockUpdateDetId,PhysicalQuantity  from EngStockAdjustmentTxn a join EngStockAdjustmentTxnDet  StockAdj1 
						on a.StockAdjustmentId  = StockAdj1.StockAdjustmentId
						where StockAdj1.StockUpdateDetId =  StockUpdateDet.StockUpdateDetId
						AND year(a.AdjustmentDate )=@pyear  AND month(a.AdjustmentDate )<=@pMonth
						 order by StockAdjustmentDetId desc) StockAdj
						 outer apply (select top 1 StockUpdateDetId,sum(Quantity) as replaceQuantity   from EngMwoPartReplacementTxn  rep1 where rep1.StockUpdateDetId =  StockUpdateDet.StockUpdateDetId
						AND year(rep1.UsedDateTime )=@pyear  AND month(rep1.UsedDateTime )<=@pMonth
						group by  StockUpdateDetId ) rep	
					--INNER JOIN EngStockAdjustmentTxnDet		AS	StockAdjustmentDet  WITH(NOLOCK)	ON  StockUpdateDet.StockUpdateDetId	= StockAdjustmentDet.StockUpdateDetId
					INNER JOIN EngSpareParts				AS	SpareParts			WITH(NOLOCK)	ON  StockUpdateDet.SparePartsId		= SpareParts.SparePartsId
					INNER JOIN FMItemMaster					AS	ItemMaster			WITH(NOLOCK)	ON	SpareParts.ItemId				= ItemMaster.ItemId
					INNER JOIN FMLovMst						AS  PartType			WITH(NOLOCK)	ON	StockUpdateDet.SparePartType		= PartType.LovId
					INNER JOIN FMLovMst						AS  UOM					WITH(NOLOCK)	ON	SpareParts.UnitOfMeasurement	= UOM.LovId
		WHERE		SpareParts.Status =1 AND ItemMaster.Status = 1 
					AND StockUpdateDet.SparePartsId=@pSparePartsId
					--AND CAST(StockUpdate.Date AS DATE) BETWEEN CAST(@MonthStartDate AS date) AND CAST(@MonthEndDate AS date)
					AND year(StockUpdate.Date )=@pyear  AND month(StockUpdate.Date )<=@pMonth
					AND ( (ISNULL(@pBinNo,'') = '' ) OR StockUpdateDet.BinNo = @pBinNo )
		ORDER BY SpareParts.PartNo DESC



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
