USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSFacilityEquipToolsConsumeMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSFacilityEquipToolsConsumeMst]
AS
SELECT       
  A.CustomerId
 ,A.FacilityId
 ,FETCId      
 ,ItemCode          
 ,ItemDescription          
 ,B.FieldValue as ItemType          
 ,C.FieldValue as Status          
 ,EffectiveFromDate          
 ,EffectiveToDate        
 ,A.ModifiedDate
 ,A.ModifiedDateUTC
 ,A.IsDeleted
 --@TotalRecords AS TotalRecords          
FROM          
 dbo.LLSFacilityEquipToolsConsumeMst A          
INNER JOIN          
 dbo.FMLovMst as B ON A.ItemType =B.LovId          
INNER JOIN          
dbo.FMLovMst as C ON A.Status =C.LovId 
WHERE ISNULL(A.IsDeleted,'')=''


GO
