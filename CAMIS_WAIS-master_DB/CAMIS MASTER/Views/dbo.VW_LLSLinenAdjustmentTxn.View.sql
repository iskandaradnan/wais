USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenAdjustmentTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_LLSLinenAdjustmentTxn]
AS
SELECT            
A.CustomerId
,A.FacilityId
,A.LinenAdjustmentId        
,YEAR(A.DocumentDate) AS Year                
,FORMAT (A.DocumentDate, 'MMMM') as Month                
,A.DocumentNo                
,A.DocumentDate                
,B.StaffName AS AuthorisedBy                
,D.FieldValue AS Status                
,A.ModifiedDate
,A.ModifiedDateUTC
,A.IsDeleted
                 
-- @TotalRecords AS TotalRecords                  
       
FROM dbo.LLSLinenAdjustmentTxn A                
INNER JOIN dbo.UMUserRegistration B                 
ON A.AuthorisedBy =B.UserRegistrationId                
LEFT JOIN dbo.LLSLinenInventoryTxn C                
ON A.LinenInventoryId =C.LinenInventoryId                
INNER JOIN dbo.FMLovMst D                
ON A.Status = D.LovId                
WHERE ISNULL(A.IsDeleted,'')=''
AND ISNULL(C.IsDeleted,'')=''



GO
