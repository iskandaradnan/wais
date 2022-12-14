USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[vwLLSTotalWeightbyMonth]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwLLSTotalWeightbyMonth]
AS
SELECT        'Total CLI Weight (Kg)' AS Description, MONTH(DeliveryDate1st) AS MONTH, DAY(DeliveryDate1st) AS Date, SUM(DeliveryWeight1st) AS Weight
FROM            LLSCleanLinenIssueTxn
GROUP BY DAY(DeliveryDate1st), MONTH(DeliveryDate1st)
UNION
SELECT        'Total CLD Weight (Kg)' AS Description, MONTH(DateReceived) AS MONTH, DAY(DateReceived) AS DATE, SUM(TotalWeightKg) AS Weight
FROM            LLSCleanLinenDespatchTxn
GROUP BY DAY(DateReceived), MONTH(DateReceived)
UNION
SELECT        'Total SLC Weight (Kg)' AS Description, MONTH(a.CollectionDate) AS MONTH, DAY(a.CollectionDate) AS DATE, SUM(b.weight) AS Weight
FROM            LLSSoiledLinenCollectionTxn a LEFT JOIN
                         LLSSoiledLinenCollectionTxnDet b ON a.SoiledLinenCollectionId = b.SoiledLinenCollectionId
GROUP BY DAY(a.CollectionDate), MONTH(a.CollectionDate)
GO
