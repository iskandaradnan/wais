USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARP_Propsal_SaveUpdate]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================  
--APPLICATION        : UETrack  
--NAME    : [uspFM_EngARP_Propsal 1_Save]  
--AUTHORS   : PRANAY KUMAR  
--DATE    : 19-NOV-2019  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init                : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--PRANAY KUMAR          : 19-NOV-2019 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
  
   
  
  
CREATE PROCEDURE  [dbo].[uspFM_EngARP_Propsal_SaveUpdate]                            
(    
    @ARPProposalID int,  
    @Model nvarchar(100),  
    @Brand nvarchar(100),  
    @Manufacturer nvarchar(100) ,  
    @EstimationPrice int ,  
    @SupplierName nvarchar(100) ,  
    @ContactNo int ,    
    --@CreatedBy int,  
    --@CreatedDate datetime,  
    --@ModifiedBy int,  
    --@ModifiedDate datetime,  
    --@ModifiedDateUTC datetime,  
    --@GuId uniqueidentifier,  
    @ARPID int,  
 @PROP_ID int  
)  
AS        
  
   
  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN   
    INSERT INTO [EngARP_Propsal] (  
    [ARP_Proposal_ID],[Model],[Brand],[Manufacturer],[Estimation Price(RM)],[Supplier Name] ,[Contact No]  
      --,[CreatedBy]  
      --,[CreatedDate]  
      --,[ModifiedBy]  
      --,[ModifiedDate]  
      --,[ModifiedDateUTC]  
      --,[Active]  
      --,[Builtin]  
      --,[GuId]  
   ,[ARPID]  
   ,[PROP_ID]  
    ) values(  
     @ARPProposalID, @Model,  @Brand, @Manufacturer,@EstimationPrice, @SupplierName, @ContactNo,  
 --    1,  
 --    GETDATE(),   
 --     1,  
 --     GETDATE(),  
 --    GETUTCDATE(),   
 -- 1,  
 --'TRUE',  
 --   NEWID(),  
 @ARPID,  
 @PROP_ID  
    )  
END   
BEGIN    
UPDATE [EngARP_Propsal] SET    
    [Model]=@Model,  
    [Brand]=@Brand,  
    [Manufacturer]=@Manufacturer,  
    [Estimation Price(RM)]=@EstimationPrice,  
    [Supplier Name]=@SupplierName,   
 [Contact No]=@ContactNo,  
    --CreatedBy =@CreatedBy,  
    --CreatedDate = GETDATE(),  
    --ModifiedBy =@ModifiedBy,  
    --ModifiedDate = GETDATE(),  
    --ModifiedDateUTC =GETUTCDATE(),  
    --GuId=NEWID(),  
 [ARPID]=@ARPID,  
 [PROP_ID]=@PROP_ID  
WHERE  ARP_Proposal_ID = @ARPProposalID  
END   
   
BEGIN   
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
SET NOCOUNT OFF  
END  
END
GO
