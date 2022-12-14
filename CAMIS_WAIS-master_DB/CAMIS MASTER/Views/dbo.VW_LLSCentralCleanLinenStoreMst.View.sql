USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSCentralCleanLinenStoreMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSCentralCleanLinenStoreMst]
AS
SELECT                
  A.CustomerId
 ,A.FacilityId
 ,A.CCLSid               
 ,FMLovMst1.FieldValue as StoreType    
 ,A.StoreType AS StoreTypeID    
 ,A.ModifiedDate
 ,A.ModifiedDateUTC
 ,A.IsDeleted
-- @TotalRecords AS TotalRecords                            
                
FROM dbo.LLSCentralCleanLinenStoreMst A                
INNER JOIN dbo.FMLovMst as FMLovMst1                 
ON A.StoreType =FMLovMst1.LovId                 
WHERE ISNULL(A.IsDeleted,'')=''

GO
