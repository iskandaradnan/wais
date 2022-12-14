USE [UetrackMasterdbPreProd]
GO
/****** Object:  View [dbo].[VW_LLSLinenRepairTxn]    Script Date: 20-09-2021 16:29:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LLSLinenRepairTxn]
AS
SELECT          
 A.CustomerId,
 A.FacilityId,
 A.LinenRepairId,          
 A.DocumentNo,            
 A.DocumentDate,            
 UMUserRegistration1.StaffName AS RepairedBy,            
 UMUserRegistration2.StaffName AS CheckBy,            
 A.Remarks,   
 A.ModifiedDate,
 A.ModifiedDateUTC,
 A.IsDeleted
 --@TotalRecords AS TotalRecords             
FROM dbo.LLSLinenRepairTxn A            
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration1             
ON A.RepairedBy = UMUserRegistration1.UserRegistrationId            
INNER JOIN dbo.UMUserRegistration AS UMUserRegistration2             
ON A.CheckedBy = UMUserRegistration2.UserRegistrationId       
WHERE ISNULL(A.IsDeleted,'')=''
GO
