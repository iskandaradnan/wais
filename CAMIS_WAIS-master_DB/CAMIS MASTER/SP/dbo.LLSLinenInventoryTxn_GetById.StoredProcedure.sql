USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInventoryTxn_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LLSLinenInventoryTxn_GetById]                  
(                  
 @Id INT           
)                  
                   
AS                   
                  
-- Exec LLSLinenInventoryTxn_GetById 89                  
                  
--/*=====================================================================================================================                  
--APPLICATION  : UETrack                  
--NAME    : LLSLinenInventoryTxn_GetById                  
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID                  
--AUTHORS   : BIJU NB                  
--DATE    : 13-FEB-2020              
-------------------------------------------------------------------------------------------------------------------------                  
--VERSION HISTORY                   
--------------------:---------------:---------------------------------------------------------------------------------------                  
--Init    : Date          : Details                  
--------------------:---------------:---------------------------------------------------------------------------------------                  
--BIJU NB           : 13-FEB-2020:                   
-------:------------:----------------------------------------------------------------------------------------------------*/                  
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
  Declare @StoreType As INT       
  SELECT       
  @StoreType = StoreType From dbo.LLSLinenInventoryTxn      
  WHERE LinenInventoryId=@Id      
  IF      
  @StoreType= '10171'      
  BEGIN      
      
SELECT              
 E.LovId AS StoreType,              
 A.DocumentNo,              
 A.Date,       
 A.VerifiedBy AS VerifiedById,    
 D.StaffName AS VerifiedBy,              
 SUM(F.CCLSInUse+F.CCLSInUse) AS TotalPcs,              
 SUM(F.CCLSInUse) AS TotalInUse,              
 SUM(F.CCLSShelf) AS TotalShelf,              
 A.Remarks              
              
FROM dbo.LLSLinenInventoryTxn A              
--INNER JOIN dbo.LLSUserAreaDetailsMst B               
--ON A.UserAreaId = B.LLSUserAreaId              
              
--INNER JOIN dbo.MstLocationUserArea C               
--ON B.UserAreaCode = C.UserAreaCode              
              
        
INNER JOIN dbo.UMUserRegistration D              
ON A.VerifiedBy= D.UserRegistrationId               
              
INNER JOIN dbo.FMLovMst E              
ON A.StoreType = E.LovId              
              
INNER JOIN dbo.LLSLinenInventoryTxnDet F              
ON A.LinenInventoryId =F.LinenInventoryId              
              
WHERE A.LinenInventoryId=@ID              
              
GROUP BY              
 E.LovId,              
 A.DocumentNo,              
 A.Date,         
 A.VerifiedBy,    
 --B.UserAreaCode,              
 --C.UserAreaName,              
 D.StaffName,              
 A.Remarks               
              
END          
ELSE      
BEGIN      
SELECT            
 A.LinenInventoryId,    
 E.LovId AS StoreType,            
 A.DocumentNo,            
 A.Date,     
 A.VerifiedBy AS VerifiedById,    
 A.UserAreaId,    
 B.UserAreaCode,            
 C.UserAreaName,            
 D.StaffName AS VerifiedBy,            
 SUM(F.InUse+F.Shelf) AS TotalPcs,            
 SUM(F.InUse) AS TotalInUse,            
 SUM(F.Shelf) AS TotalShelf,            
 A.Remarks            
            
FROM dbo.LLSLinenInventoryTxn A            
INNER JOIN dbo.LLSUserAreaDetailsMst B             
ON A.UserAreaId = B.LLSUserAreaId            
            
INNER JOIN dbo.MstLocationUserArea C             
ON B.UserAreaCode = C.UserAreaCode            
            
      
INNER JOIN dbo.UMUserRegistration D            
ON A.VerifiedBy= D.UserRegistrationId             
            
INNER JOIN dbo.FMLovMst E            
ON A.StoreType = E.LovId            
            
INNER JOIN dbo.LLSLinenInventoryTxnDet F            
ON A.LinenInventoryId =F.LinenInventoryId            
            
WHERE A.LinenInventoryId=@ID            
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(B.IsDeleted,'')=''

            
GROUP BY       
 A.LinenInventoryId,    
 E.LovId,            
 A.DocumentNo,            
 A.Date,       
 A.VerifiedBy,    
 A.UserAreaId,    
 B.UserAreaCode,            
 C.UserAreaName,            
 D.StaffName,         
 A.Remarks             
END      
END TRY                  
BEGIN CATCH                  
                  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                  
                  
THROW                  
                  
END CATCH                  
SET NOCOUNT OFF                  
END
GO
