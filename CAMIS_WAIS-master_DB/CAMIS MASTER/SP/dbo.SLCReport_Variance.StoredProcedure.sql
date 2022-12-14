USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[SLCReport_Variance]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SLCReport_Variance]   
AS  
  
select month(a.CollectionDate) as Month, convert(date, a.CollectionDate) as Date,  day(a.CollectionDate) as Day, sum(b.TotalWhiteBag) as TotalWhiteBag, sum(b.TotalRedBag) as TotalRedBag, sum(b.TotalGreenBag) as TotalGreenBag, sum(b.TotalBrownBag) as TotalBrownBag,   
sum(b.TotalQuantity) as TotalQuantity  
INTO #tempSLCReport  
FROM LLSSoiledLinenCollectionTxn a  
LEFT JOIN LLSSoiledLinenCollectionTxnDet b  
ON a.SoiledLinenCollectionId = b.SoiledLinenCollectionId  
GROUP BY month(a.CollectionDate), convert(date, a.CollectionDate), day(a.CollectionDate)  
ORDER BY convert(date, a.CollectionDate)  
  
---------------------------------  
  
SELECT Month, Day, ITEM, Total  
INTO #tempSLCReport2  
FROM #tempSLCReport  
  
UNPIVOT   
(  
Total  
FOR ITEM IN (TotalWhitebag, TotalRedBag,TotalGreenBag,TotalBrownBag, TotalQuantity)  
)T  
  
---------------------------  
  
SELECT *   
INTO #tempSLCReport3  
FROM  
(  
SELECT Month, Item, Day, total  
FROM  #tempSLCReport2  
)   
AS T  
Pivot  
(  
SUM(Total)   
FOR Day in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31])  
) AS S  
  
---------------------------  
  

  
GO
