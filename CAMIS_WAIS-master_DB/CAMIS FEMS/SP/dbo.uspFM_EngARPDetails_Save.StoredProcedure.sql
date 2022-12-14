USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARPDetails_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
  @ARPID int,          
  --@CustomerID int,        
  --@FacilityID int,        
  @BERno nvarchar(50),     
   @AssetNo nvarchar(50) ,        
  @ConditionAppraisalNo nvarchar(50) ,          
    @BERRemarks  nvarchar(500)  
  --@AssetName nvarchar(50) ,         
    --@Justification  nvarchar(500)      
  --@CreatedBy int,          
  --@CreatedDate datetime,          
  --@CreatedDateUTC datetime,          
  --@ModifiedBy int,          
  --@ModifiedDate datetime,          
  --@ModifiedDateUTC datetime,          
  --@GuId uniqueidentifier,          
  --@SelectedProposal nvarchar(100),          
  --@Justification nvarchar(500)          
             
  )          
  AS                
          
  BEGIN          
  SET NOCOUNT ON          
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
  BEGIN           
  INSERT INTO EngARP_Details (          
  BERno,    
  AssetNo,        
  ConditionAppraisalNo,          
  BERRemarks        
  --CreatedBy ,          
  --CreatedDate ,          
  --CreatedDateUTC ,          
  --ModifiedBy ,          
  --ModifiedDate ,          
  --ModifiedDateUTC ,          
  --Timestamp ,          
  --GuId         
  )           
  values          
  (          
     
  @BERno,   
  @AssetNo,          
  @ConditionAppraisalNo,          
  @BERRemarks          
  --1,          
  --GETDATE(),          
  --GETUTCDATE(),          
  -- 1,          
  -- GETDATE(),          
  --   GETUTCDATE(),           
  --  GETDATE(),          
  --  NEWID()         
  )          
          
  END           
  BEGIN            
  UPDATE EngARP_Details SET            
  --ARPID=@ARPID,          
    
  BERNo=@BERno,   
  AssetNo=@AssetNo,        
  ConditionAppraisalNo=@ConditionAppraisalNo,          
  BERRemarks=@BERRemarks       
  --CreatedBy =@CreatedBy,          
  --CreatedDate = GETDATE(),          
  --CreatedDateUTC =GETUTCDATE(),          
  --ModifiedBy =@ModifiedBy,          
  --ModifiedDate = GETDATE(),          
  --ModifiedDateUTC =GETUTCDATE(),          
  --GuId=NEWID()          
  WHERE  BERno = @BERno           
  END           
           
  BEGIN           
  INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
  VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
          
  SET NOCOUNT OFF          
  END          
  END
GO
