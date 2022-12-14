USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[V_EngMonthlyStockRegister_Export]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_EngMonthlyStockRegister_Export] 
AS
		SELECT		distinct StockUpdate.FacilityId,
					SpareParts.SparePartsId,
					SpareParts.PartNo,
					SpareParts.PartDescription,
					ItemMaster.ItemNo,
					ItemMaster.ItemDescription,
					UOM.FieldValue							AS UOM,
					SpareParts.MinLevel						AS MinimumLevel,
					PartType.FieldValue						AS StockType,
					cast(YEAR (StockUpdate.Date)as int) AS [Year],
					cast(Month (StockUpdate.Date)as int) AS [Month],
					DATENAME(month, StockUpdate.Date) AS [MonthName],
					SUM(CASE
					WHEN 5 =  MONTH(StockUpdate.Date) THEN ISNULL(StockUpdateDet.Quantity,0)
					ELSE 
					0
					END )AS CURRENTQUANTITY,
					SUM(CASE
					WHEN 5 <>  MONTH(StockUpdate.Date) THEN ISNULL(StockUpdateDet.Quantity,0)
					ELSE 
					0
					END )AS PREVIOUSQUANTITY,
					max(StockUpdateDet.ModifiedDateUTC) ModifiedDateUTC
		FROM		EngStockUpdateRegisterTxn				AS	StockUpdate		WITH(NOLOCK)	
					INNER JOIN EngStockUpdateRegisterTxnDet	AS	StockUpdateDet  WITH(NOLOCK)	ON  StockUpdate.StockUpdateId		= StockUpdateDet.StockUpdateId
					INNER JOIN EngSpareParts				AS	SpareParts		WITH(NOLOCK)	ON  StockUpdateDet.SparePartsId		= SpareParts.SparePartsId
					INNER JOIN FMItemMaster					AS	ItemMaster		WITH(NOLOCK)	ON	SpareParts.ItemId				= ItemMaster.ItemId
					INNER JOIN FMLovMst						AS  PartType		WITH(NOLOCK)	ON	SpareParts.SparePartType		= PartType.LovId
					INNER JOIN FMLovMst						AS  UOM				WITH(NOLOCK)	ON	SpareParts.UnitOfMeasurement	= UOM.LovId
		WHERE		SpareParts.Status =1 AND ItemMaster.Status = 1
					--AND YEAR(StockUpdate.Date)=(ISNULL(@pYear,0))	AND MONTH(StockUpdate.Date)=(ISNULL(@pMonth,0)) 
					--AND CAST(StockUpdate.Date AS DATE) BETWEEN @MonthStartDate AND @MonthEndDate
					--AND ((ISNULL(@pPartNo,'') = '' ) OR SpareParts.PartNo LIKE + '%' + @pPartNo + '%')
					--AND ( (ISNULL(@pPartDescription,'') = '' ) OR SpareParts.PartDescription LIKE + '%' + @pPartDescription + '%')
					--AND ((ISNULL(@pItemCode,'') = '' ) OR ItemMaster.ItemNo LIKE + '%' + @pItemCode + '%')
					--AND ((ISNULL(@pItemDescription,'') = '' )  OR ItemMaster.ItemDescription LIKE + '%' + @pItemDescription + '%')
					--AND ((ISNULL(@pSparePartType,'') = '' )  OR PartType.FieldValue LIKE + '%' + @pSparePartType + '%')
					--OR SpareParts.PartNo = ISNULL(@pPartNo,'') 
					--OR SpareParts.PartDescription = ISNULL(@pPartDescription,'') 
					--OR ItemMaster.ItemNo = ISNULL(@pItemCode,'') 
					--OR ItemMaster.ItemDescription = ISNULL(@pItemDescription,'')
					--OR SpareParts.SparePartType = (ISNULL(@pSparePartType,0))
					
		GROUP BY StockUpdate.FacilityId,SpareParts.SparePartsId,SpareParts.PartNo,SpareParts.PartDescription,
		ItemMaster.ItemNo,ItemMaster.ItemDescription,UOM.FieldValue,SpareParts.MinLevel,PartType.FieldValue,
		cast(YEAR (StockUpdate.Date)as int) ,
		cast(Month (StockUpdate.Date)as int) ,
		DATENAME(month, StockUpdate.Date) 
		--,StockUpdate.Date--,StockUpdate.ModifiedDateUTC			
		--ORDER BY SpareParts.PartNo DESC
GO
