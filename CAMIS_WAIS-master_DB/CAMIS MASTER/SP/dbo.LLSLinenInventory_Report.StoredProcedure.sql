USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventory_Report]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LLSLinenInventory_Report]
AS
BEGIN

SELECT A.LinenCode
,A.LinenDescription
,SUM(ISNULL(B.StoreBalance,0)) AS StoreBalance
,SUM(ISNULL(C.QuantityInjected,0)) AS QuantityInjected
,SUM(ISNULL(D.InUse,0))+SUM(ISNULL(D.SHELF,0)) AS QuantityHand
,SUM(ISNULL(C.QuantityInjected,0))-(SUM(ISNULL(D.InUse,0))+SUM(ISNULL(D.SHELF,0))) AS TotalQuantity
FROM LLSLinenItemDetailsMst A
LEFT OUTER JOIN LLSCentralCleanLinenStoreMstDet B
ON A.LinenItemId=B.LinenItemId
LEFT OUTER JOIN LLSLinenInjectionTxnDet C
ON A.LinenItemId=C.LinenItemId
LEFT OUTER JOIN LLSLinenInventoryTxnDet D
ON A.LinenItemId=D.LinenItemId
GROUP BY A.LinenCode
,A.LinenDescription


END
GO
