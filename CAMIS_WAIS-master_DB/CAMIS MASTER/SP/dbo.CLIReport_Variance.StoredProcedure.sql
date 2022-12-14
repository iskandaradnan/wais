USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[CLIReport_Variance]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[CLIReport_Variance]   
AS  
  
  
select month(DeliveryDate1st) as Month, day(DeliveryDate1st) as Day, count(a.clino) as Total_CLI, sum(b.totalitemrequested) as Total_Request, sum(a.totalitemissued) as Total_Issued,   
sum(a.totalitemshortfall) as Total_Shortfall,   
sum(b.totalbagrequested) as Total_Bag_Requested,sum(a.TotalBagIssued) as Total_Bag_Issued, sum(a.totalbagshortfall) as Total_Bag_Shortfall  
INTO #tempCLIReport  
FROM LLSCleanLinenIssueTxn a  
LEFT JOIN LLSCleanLinenRequestTxn b  
ON a.CleanLinenRequestId = b.CleanLinenRequestId  
GROUP BY convert(date, DeliveryDate1st),month(DeliveryDate1st),day(DeliveryDate1st)  
ORDER BY convert(date, DeliveryDate1st)  
  
----------  
  
  
SELECT Month, Day, ITEM, Total  
INTO #tempCLIReport2  
FROM #tempCLIReport  
  
UNPIVOT   
(  
Total  
FOR ITEM IN (Total_CLI, Total_Request,Total_Issued,Total_Shortfall, Total_Bag_Requested,Total_Bag_Issued,Total_Bag_Shortfall)  
)T  
   
----------  
  
  
SELECT *   
INTO #tempCLIReport3  
FROM  
(  
SELECT Month, Item, Day, total  
FROM  #tempCLIReport2  
)   
AS T  
Pivot  
(  
SUM(Total)   
FOR Day in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31])  
) AS S  
  
----------  
  
select * from #tempCLIReport3 order by month  
GO
