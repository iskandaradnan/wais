USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionFrequency_GetAll]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[DeductionFrequency_GetAll]      
AS      
BEGIN       
SELECT A.LovId,A.FieldValue       
FROM [uetrackMasterdbPreProd].[DBO].FMLovMst A       
WHERE LovKey = 'Report'      
ORDER BY CAST(FieldCode AS INT) ASC      
END      
      
      
      
      
GO
