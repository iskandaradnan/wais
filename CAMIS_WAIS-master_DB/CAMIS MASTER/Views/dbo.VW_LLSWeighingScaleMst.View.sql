USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSWeighingScaleMst]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSWeighingScaleMst]
AS
SELECT         
 A.CustomerId,
 A.FacilityId,
 A.WeighingScaleId,        
 B.FieldValue as IssuedBy,            
 ItemDescription,            
 SerialNo,            
 IssuedDate,            
 ExpiryDate,            
 C.FieldValue as Status,          
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted
 --@TotalRecords AS TotalRecords            
FROM            
 dbo.LLSWeighingScaleMst A            
INNER JOIN            
 dbo.FMLovMst as B ON A.IssuedBy =B.LovId            
INNER JOIN            
 dbo.FMLovMst as C ON A.Status =C.LovId             
 WHERE ISNULL(A.IsDeleted,'')=''

GO
