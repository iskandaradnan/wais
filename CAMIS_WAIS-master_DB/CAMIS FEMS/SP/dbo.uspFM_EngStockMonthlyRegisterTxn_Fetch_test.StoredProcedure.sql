USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngStockMonthlyRegisterTxn_Fetch_test]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngStockMonthlyRegisterTxn_Fetch
Description			: Stock search popup
Authors				: Balaji M S
Date				: 08-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngStockMonthlyRegisterTxn_Fetch  @pYear=2018,@pMonth=5,@pPartNo=NULL,@pPartDescription=NULL,@pItemCode=NULL,@pItemDescription=NULL,
@pSparePartType='Inventory',@pPageIndex=1,@pPageSize=5
EXEC uspFM_EngStockMonthlyRegisterTxn_Fetch  @pYear=2018,@pMonth=5,@pPageIndex=1,@pPageSize=5,@pCustomerId=1

EXEC uspFM_EngStockMonthlyRegisterTxn_Fetch  @pYear=2018,@pMonth=7,@pPageIndex=1,@pPageSize=50,
@pCustomerId=1

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/
create PROCEDURE  [dbo].[uspFM_EngStockMonthlyRegisterTxn_Fetch_test]
  @pYear					INT,
  @pMonth					INT,                           
  @pPartNo					NVARCHAR(100)		=NULL,
  @pPartDescription			NVARCHAR(200)		=NULL,
  @pItemCode				NVARCHAR(100)       =NULL,
  @pItemDescription			NVARCHAR(200)		=NULL,
  @pSparePartType			NVARCHAR(200)		=NULL,
  @pPageIndex				INT,
  @pPageSize				INT,
  @pCustomerId				INT

AS                                              

BEGIN TRY

-- Paramter Validation 

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration

	DECLARE @TotalRecords	INT
	DECLARE @MonthStartDate DATE
	DECLARE @MonthEndDate	DATE
	DECLARE @pTotalPage		NUMERIC(24,2)
	DECLARE @pTotalPageCalc	NUMERIC(24,2)
-- Default Values
	
	set @MonthStartDate = DATEFROMPARTS(@pYear,@pMonth,1)
	set @MonthEndDate	= EOMONTH (DATEFROMPARTS(@pYear,@pMonth,1))

	DECLARE @MonthStartDatePre DATE
	DECLARE @MonthEndDatePre	DATE

	set @MonthStartDatePre =  DATEADD(MONTH,-1,DATEFROMPARTS(@pYear,@pMonth,1))
	set @MonthEndDatePre	= EOMONTH (DATEFROMPARTS(@pYear,(@pMonth-1),1))
-- Execution

	IF EXISTS (SELECT 1 FROM EngStockUpdateRegisterTxn WHERE MONTH(DATE) = @pMonth AND FacilityId	=	@pCustomerId)
	BEGIN


-- To take Previous month calculation

		SELECT		SpareParts.SparePartsId,
					SUM(CASE
					WHEN MONTH(StockUpdate.Date) = (@pMonth-1)  THEN ISNULL(StockUpdateDet.Quantity,0)
					ELSE 
					0
					END )AS PREVIOUSQUANTITY
		INTO #MonthlyStockPrev
		FROM		EngStockUpdateRegisterTxn				AS	StockUpdate		WITH(NOLOCK)	
					INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUpdateDet  WITH(NOLOCK)	ON  StockUpdate.StockUpdateId		= StockUpdateDet.StockUpdateId
					INNER JOIN EngSpareParts				AS	SpareParts		WITH(NOLOCK)	ON  StockUpdateDet.SparePartsId		= SpareParts.SparePartsId
					INNER JOIN FMItemMaster					AS	ItemMaster		WITH(NOLOCK)	ON	SpareParts.ItemId				= ItemMaster.ItemId
					INNER JOIN FMLovMst						AS  PartType		WITH(NOLOCK)	ON	StockUpdateDet.SparePartType		= PartType.LovId
					INNER JOIN FMUOM						AS  UOM				WITH(NOLOCK)	ON	SpareParts.UnitOfMeasurement	= UOM.UOMId
					INNER JOIN MstLocationFacility			AS  Facility		WITH(NOLOCK)	ON	StockUpdateDet.FacilityId	= Facility.FacilityId
		WHERE		SpareParts.Status =1 AND ItemMaster.Status = 1
					--AND YEAR(StockUpdate.Date)=(ISNULL(@pYear,0))	AND MONTH(StockUpdate.Date)=(ISNULL(@pMonth,0)) 
					AND CAST(StockUpdate.Date AS DATE) BETWEEN CAST(@MonthStartDatePre AS date) AND CAST(@MonthEndDatePre AS date)
					AND ((ISNULL(@pPartNo,'') = '' ) OR SpareParts.PartNo LIKE + '%' + @pPartNo + '%')
					AND ( (ISNULL(@pPartDescription,'') = '' ) OR SpareParts.PartDescription LIKE + '%' + @pPartDescription + '%')
					AND ((ISNULL(@pItemCode,'') = '' ) OR ItemMaster.ItemNo LIKE + '%' + @pItemCode + '%')
					AND ((ISNULL(@pItemDescription,'') = '' )  OR ItemMaster.ItemDescription LIKE + '%' + @pItemDescription + '%')
					AND ((ISNULL(@pSparePartType,'') = '' )  OR PartType.FieldValue LIKE + '%' + @pSparePartType + '%')
					AND ((ISNULL(@pCustomerId,'')='' )		OR (ISNULL(@pCustomerId,'') <> '' AND Facility.CustomerId = @pCustomerId))					
		GROUP BY SpareParts.SparePartsId,SpareParts.PartNo,	SpareParts.PartDescription,	ItemMaster.ItemNo,ItemMaster.ItemDescription,UOM.UnitOfMeasurement,SpareParts.MinLevel,PartType.FieldValue,StockUpdateDet.BinNo,Facility.FacilityCode,Facility.FacilityName--,StockUpdate.ModifiedDateUTC			
	
		SELECT		SpareParts.SparePartsId,
					Facility.FacilityCode,
					Facility.FacilityName,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					UOM.UnitOfMeasurement					AS UOM,
					SpareParts.MinLevel						AS MinimumLevel,
					PartType.FieldValue						AS StockType,
					SUM(CASE
					WHEN MONTH(StockUpdate.Date) = @pMonth  THEN ISNULL(StockUpdateDet.Quantity,0)
					ELSE 
					0
					END )AS CURRENTQUANTITY,
					CAST(NULL AS NUMERIC(24,2)) AS PREVIOUSQUANTITY,
					StockUpdateDet.BinNo
		INTO #MonthlyStockRes
		FROM		EngStockUpdateRegisterTxn				AS	StockUpdate		WITH(NOLOCK)	
					INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUpdateDet  WITH(NOLOCK)	ON  StockUpdate.StockUpdateId		= StockUpdateDet.StockUpdateId
					INNER JOIN EngSpareParts				AS	SpareParts		WITH(NOLOCK)	ON  StockUpdateDet.SparePartsId		= SpareParts.SparePartsId
					INNER JOIN FMItemMaster					AS	ItemMaster		WITH(NOLOCK)	ON	SpareParts.ItemId				= ItemMaster.ItemId
					INNER JOIN FMLovMst						AS  PartType		WITH(NOLOCK)	ON	StockUpdateDet.SparePartType		= PartType.LovId
					INNER JOIN FMUOM						AS  UOM				WITH(NOLOCK)	ON	SpareParts.UnitOfMeasurement	= UOM.UOMId
					INNER JOIN MstLocationFacility			AS  Facility		WITH(NOLOCK)	ON	StockUpdateDet.FacilityId	= Facility.FacilityId
		WHERE		SpareParts.Status =1 AND ItemMaster.Status = 1
					--AND YEAR(StockUpdate.Date)=(ISNULL(@pYear,0))	AND MONTH(StockUpdate.Date)=(ISNULL(@pMonth,0)) 
					AND CAST(StockUpdate.Date AS DATE) BETWEEN CAST(@MonthStartDate AS date) AND CAST(@MonthEndDate AS date)
					AND ((ISNULL(@pPartNo,'') = '' ) OR SpareParts.PartNo LIKE + '%' + @pPartNo + '%')
					AND ( (ISNULL(@pPartDescription,'') = '' ) OR SpareParts.PartDescription LIKE + '%' + @pPartDescription + '%')
					AND ((ISNULL(@pItemCode,'') = '' ) OR ItemMaster.ItemNo LIKE + '%' + @pItemCode + '%')
					AND ((ISNULL(@pItemDescription,'') = '' )  OR ItemMaster.ItemDescription LIKE + '%' + @pItemDescription + '%')
					AND ((ISNULL(@pSparePartType,'') = '' )  OR PartType.FieldValue LIKE + '%' + @pSparePartType + '%')
					AND ((ISNULL(@pCustomerId,'')='' )		OR (ISNULL(@pCustomerId,'') <> '' AND Facility.CustomerId = @pCustomerId))					
		GROUP BY SpareParts.SparePartsId,SpareParts.PartNo,	SpareParts.PartDescription,	ItemMaster.ItemNo,ItemMaster.ItemDescription,UOM.UnitOfMeasurement,SpareParts.MinLevel,PartType.FieldValue,StockUpdateDet.BinNo,Facility.FacilityCode,Facility.FacilityName--,StockUpdate.ModifiedDateUTC			
		
	UPDATE	B SET B.PREVIOUSQUANTITY = A.PREVIOUSQUANTITY
	FROM	#MonthlyStockPrev A 
			INNER JOIN #MonthlyStockRes B ON A.SparePartsId=B.SparePartsId
	

	SELECT @TotalRecords =  COUNT(*) 
	FROM #MonthlyStockRes

	SET @pTotalPage = CAST(@TotalRecords AS NUMERIC(24,2))/CAST(@pPageSize AS NUMERIC(24,2))
	SET @pTotalPageCalc = CEILING(@pTotalPage)

	SELECT	SparePartsId,
			FacilityCode,
			FacilityName,
			PartNo,
			PartDescription,
			ItemNo,
			ItemDescription,
			UOM,
			MinimumLevel,
			StockType,
			ISNULL(CURRENTQUANTITY,0) AS CURRENTQUANTITY,
			ISNULL(PREVIOUSQUANTITY,0) AS PREVIOUSQUANTITY,
			@TotalRecords							AS TotalRecords,
			@pTotalPageCalc							AS TotalPageCalc,
			BinNo
	FROM #MonthlyStockRes
	ORDER BY PartNo DESC
	OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY

	END

		ELSE
		BEGIN
		CREATE TABLE #TempForShow(SparePartsId INT,PartNo NVARCHAR(100),PartDescription	NVARCHAR(100),ItemNo NVARCHAR(100),
		ItemDescription NVARCHAR(100),UOM NVARCHAR(100),MinimumLevel NUMERIC(24,2),StockType NVARCHAR(100),CURRENTQUANTITY NUMERIC(24,2),PREVIOUSQUANTITY NUMERIC(24,2),TotalRecords INT,TotalPageCalc INT,BinNo NVARCHAR(25),FacilityCode  NVARCHAR(50),FacilityName  NVARCHAR(100))
		SELECT SparePartsId,PartNo,PartDescription,ItemNo,ItemDescription,UOM,MinimumLevel,StockType,CURRENTQUANTITY,PREVIOUSQUANTITY,TotalRecords,TotalPageCalc,BinNo,FacilityCode,FacilityName
		FROM #TempForShow
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
		   )

END CATCH
GO
