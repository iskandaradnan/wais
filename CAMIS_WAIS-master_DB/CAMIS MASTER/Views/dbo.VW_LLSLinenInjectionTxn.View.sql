USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenInjectionTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenInjectionTxn]  
AS   
SELECT            
   
 A.CustomerId,  
 A.FacilityId,  
 A.LinenInjectionId,          
 A.DocumentNo,            
 A.InjectionDate,            
 A.DONo AS DONo,            
 A.DODate AS DODate,            
 A.PONo AS PONo,            
 A.ModifiedDate,  
 A.ModifiedDateUTC,  
 A.IsDeleted  
-- @TotalRecords AS TotalRecords              
FROM dbo.LLSLinenInjectionTxn A            
WHERE ISNULL(A.IsDeleted,'')=''  
GO
