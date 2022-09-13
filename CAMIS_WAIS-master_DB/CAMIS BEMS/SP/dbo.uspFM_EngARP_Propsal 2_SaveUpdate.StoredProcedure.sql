USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARP_Propsal 2_SaveUpdate]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================
--APPLICATION        : UETrack
--NAME				: [uspFM_EngARP_Propsal 2_Save]
--AUTHORS			: PRANAY KUMAR
--DATE				: 19-NOV-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init                : Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--PRANAY KUMAR          : 20-NOV-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/

 


CREATE PROCEDURE  [dbo].[uspFM_EngARP_Propsal 2_SaveUpdate]                          
(  
    @ARPProposalID int,
    @Model nvarchar(100),
    @Brand nvarchar(100),
    @Manufacturer nvarchar(100) ,
    @EstimationPrice int ,
    @SupplierName nvarchar(100) ,
    @ContactNo int ,  
    @CreatedBy int,
    @CreatedDate datetime,
    @ModifiedBy int,
    @ModifiedDate datetime,
    @ModifiedDateUTC datetime,
    @GuId uniqueidentifier,
	@ARPID int
   
)
AS      

 

BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN 
    INSERT INTO [EngARP_Propsal_2] (
    [ARP Proposal 1 ID],[Model],[Brand],[Manufacturer],[Estimation Price(RM)],[Supplier Name] ,[Contact No]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[ModifiedDateUTC]
      ,[Active]
      ,[Builtin]
      ,[GuId]
	  ,[ARPID]
    ) values(
     @ARPProposalID, @Model,  @Brand, @Manufacturer,@EstimationPrice, @SupplierName, @ContactNo,
     1,
     GETDATE(), 
      1,
      GETDATE(),
     GETUTCDATE(), 
	 1,
	'TRUE',
    NEWID(),
	@ARPID
    )
END 
BEGIN  
UPDATE [EngARP_Propsal_2] SET  
    [Model]=@Model,
    [Brand]=@Brand,
    [Manufacturer]=@Manufacturer,
    [Estimation Price(RM)]=@EstimationPrice,
    [Supplier Name]=@SupplierName, 
	[Contact No]=@ContactNo,
    CreatedBy =@CreatedBy,
    CreatedDate = GETDATE(),
    ModifiedBy =@ModifiedBy,
    ModifiedDate = GETDATE(),
    ModifiedDateUTC =GETUTCDATE(),
    GuId=NEWID(),
	[ARPID]=@ARPID
WHERE  [ARP Proposal 2 ID] = @ARPProposalID
END 
 
BEGIN 
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

SET NOCOUNT OFF
END
END
GO
