USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[PBIRescheduleDate]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--SELECT * FROM EngMwoReschedulingTxn    
    
    
CREATE PROCEDURE [dbo].[PBIRescheduleDate]    
AS    
BEGIN    
    
    
DELETE FROM PBITBLRescheduleDate    
    
INSERT INTO PBITBLRescheduleDate    
(    
ASSETID     
,WorkOrderId     
,RescheduleDate     
)    
    
SELECT A.ASSETID    
       ,A.WorkOrderId    
      ,MAX(B.RescheduleDate) AS RescheduleDate    
FROM EngMaintenanceWorkOrderTxn A    
LEFT OUTER JOIN EngMwoReschedulingTxn B    
ON A.WorkOrderId=B.WorkOrderId    
GROUP BY A.ASSETID    
       ,A.WorkOrderId    
    
    
END


GO
