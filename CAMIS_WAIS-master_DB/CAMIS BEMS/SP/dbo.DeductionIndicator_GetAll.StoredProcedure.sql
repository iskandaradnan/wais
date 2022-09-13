USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionIndicator_GetAll]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[DeductionIndicator_GetAll]      
AS      
BEGIN       
SELECT IndicatorDetId, IndicatorNo       
FROM MstDedIndicatorDet      
WHERE Active = 'True' ORDER BY IndicatorDetId    
END 
GO
