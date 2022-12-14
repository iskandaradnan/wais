USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenItemDetailsMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenItemDetailsMst]
AS
SELECT        
  A.CustomerId
 ,A.FacilityId
 ,A.LinenItemId      
 ,A.LinenCode        
 ,A.LinenDescription        
 ,B.FieldValue as UOM        
 ,C.FieldValue as Material        
 ,D.FieldValue as Status        
 ,A.EffectiveDate        
 ,A.Size        
 ,E.FieldValue as Colour        
 ,F.FieldValue as Standard        
 ,A.IdentificationMark 
 ,A.LinenPrice 
 ,A.ModifiedDate
 ,A.ModifiedDateUTC
 ,A.IsDeleted
 --,@TotalRecords AS TotalRecords        
FROM        
 dbo.LLSLinenItemDetailsMst A        
INNER JOIN        
 dbo.FMLovMst  B ON A.UOM =B.LovId        
INNER JOIN        
 dbo.FMLovMst C ON A.material =C.LovId        
INNER JOIN         
 dbo.FMLovMst D ON A.Status =D.LovId        
INNER JOIN        
 dbo.FMLovMst E ON A.Colour =E.LovId        
INNER JOIN        
dbo.FMLovMst F ON A.Standard =F.LovId        
WHERE ISNULL(A.IsDeleted,'')=''
GO
