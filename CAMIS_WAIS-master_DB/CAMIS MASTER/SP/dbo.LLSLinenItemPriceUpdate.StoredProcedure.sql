USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemPriceUpdate]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---EXEC LLSLinenItemPriceUpdate  
  
CREATE PROCEDURE [dbo].[LLSLinenItemPriceUpdate]  
AS  
  
BEGIN  
  
-------WHEN EVER ANY UPDATE ON LINEN PRICE IN LINEN INJECTION UPDATE THE LINEN ITEM MASTER  
  
UPDATE A  
SET A.LinenPrice=B.LinenPrice  
,A.ModifiedDate=GETDATE()  
FROM LLSLinenItemDetailsMst A  
INNER JOIN LLSLinenInjectionTxnDet B  
ON A.LinenItemId=B.LinenItemId  
  
END
GO
