USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARPDetails_Save]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --alter table EngARP_Details  add ItemNo VARCHAR(100)        
  --alter table EngARP_Details add PurchaseCost NUMERIC(18,2)        
  --alter table EngARP_Details add PurchaseDate DATETIME        
  --alter table EngARP_Details add BatchNo INT        
  --alter table EngARP_Details add PackageCode VARCHAR(100)        
        
--alter table EngARP_Details add  AssetTypeCodeID INT        
--sp_helptext uspFM_EngARPDetails_Save              
              
  /****** Object:  StoredProcedure [dbo].[TEST_BlockMst_Save]    Script Date: 19/11/2019 5:45:06 PM ******/                        
                        
                    
                        
  -- Exec [SaveUserRole]                         
                        
  --/*=====================================================================================================================                        
  --APPLICATION  : UETrack                        
  --NAME    : Save Master Data TEST                        
  --DESCRIPTION  : SAVE RECORD IN UMUSERROLE TABLE                         
  --AUTHORS   : BIJU NB                        
  --DATE    : 06-AUG-2019                        
  -------------------------------------------------------------------------------------------------------------------------                        
  --VERSION HISTORY                         
  --------------------:---------------:---------------------------------------------------------------------------------------                        
  --Init    : Date          : Details                        
  --------------------:---------------:---------------------------------------------------------------------------------------                        
  --BIJU NB           : 06-AUG-2019 :                         
  -------:------------:----------------------------------------------------------------------------------------------------*/                        
                        
                        
  CREATE PROCEDURE  [dbo].[uspFM_EngARPDetails_Save]                                                   
  (                          
        
  @CustomerID int,                      
  @FacilityID int,                      
  @BERno nvarchar(50),  --1                 
  @AssetNo nvarchar(50) ,         
      
  @ConditionAppraisalNo nvarchar(50) ,  --3                      
  @BERRemarks  nvarchar(500) ,              
  @AssetName nvarchar(50) ,                       
  @AssetTypeDescription  nvarchar(500),            
  @AssetTypeCodeID INT,        
  @DepartmentNameID int,            
  @LocationNameID int,           
  @ApplicationDate datetime,    --2        
  --added       
   @AssetID int ,      
  @ItemNo VARCHAR(100),        
  --@Quantity INT,        
  @PurchaseCost NUMERIC(18,2),        
  @PurchaseDate DATETIME,        
  @BatchNo INT,        
  @PackageCode VARCHAR(100)        
        
             
                           
  )                        
  AS                              
                        
  BEGIN                        
  SET NOCOUNT ON                        
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED                        
  BEGIN    
  DECLARE @Table TABLE (ID INT)        
  INSERT INTO EngARP_Details (                        
  CustomerID,        
  FacilityID,        
  BERno,                  
  AssetNo,                      
  ConditionAppraisalNo,                        
  BERRemarks,          
  AssetName,          
  AssetTypeDescription,          
  DepartmentNameID,          
  LocationNameID,     
  ApplicationDate,    
  --CreatedBy ,                        
  CreatedDate ,                        
  CreatedDateUTC ,                        
  ModifiedBy ,                        
  ModifiedDate ,                        
  ModifiedDateUTC ,                        
  GuId,     
  AssetID,    
  ItemNo,        
  PurchaseCost,        
  PurchaseDate,        
  BatchNo,        
  PackageCode,        
  AssetTypeCodeID        
  )     
  OUTPUT INSERTED.ARPID INTO @Table        
  values                        
(                        
  @CustomerID,        
  @FacilityID,        
  @BERno,                 
  @AssetNo,                        
  @ConditionAppraisalNo,                        
  @BERRemarks ,          
   @AssetName,          
  @AssetTypeDescription,          
  @DepartmentNameID,          
  @LocationNameID,      
   @ApplicationDate,    
  --1,                        
  GETDATE(),                        
  GETUTCDATE(),                        
  1,                        
  GETDATE(),                        
 GETUTCDATE(),                         
   NEWID(),     
  @AssetID,    
  @ItemNo,        
  @PurchaseCost,        
  @PurchaseDate,        
  @BatchNo,        
  @PackageCode,        
  @AssetTypeCodeID        
  )                        
                        
  END                         
 SELECT ARPID                                          
      ,[Timestamp]                                          
   ,'' ErrorMessage                                          
      --,GuId                                           
FROM EngARP_Details WHERE ARPID IN (SELECT ID FROM @Table)                                            
                    
                         
  BEGIN                         
  INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                        
  VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                        
                  
                        
  SET NOCOUNT OFF                        
  END                        
  END









GO
