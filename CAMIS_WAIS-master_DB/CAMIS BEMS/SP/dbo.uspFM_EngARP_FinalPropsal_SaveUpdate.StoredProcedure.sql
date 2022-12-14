USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngARP_FinalPropsal_SaveUpdate]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=====================================================================================================================
--APPLICATION        : UETrack
--NAME				: [uspFM_EngARP_FinalPropsal_Saveupdate]
--AUTHORS			: PRANAY KUMAR
--DATE				: 20-NOV-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init                : Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--PRANAY KUMAR          : 20-NOV-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/

 


CREATE PROCEDURE  [dbo].[uspFM_EngARP_FinalPropsal_SaveUpdate]                          
(  
    @ARPFinalProposalID int,
	@SelectedProposal nvarchar(100),
    @Justification nvarchar(500),
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
    INSERT INTO EngARP_Final_Proposal (
    [ARP Final Proposal ID],[Selected Proposal],[Justification]
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
     @ARPFinalProposalID, @SelectedProposal,  @Justification,
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
UPDATE EngARP_Final_Proposal SET  
    [Selected Proposal]=@SelectedProposal,
    [Justification]=@Justification,
    CreatedBy =@CreatedBy,
    CreatedDate = GETDATE(),
    ModifiedBy =@ModifiedBy,
    ModifiedDate = GETDATE(),
    ModifiedDateUTC =GETUTCDATE(),
    GuId=NEWID(),
	[ARPID]=@ARPID
WHERE  [ARP Final Proposal ID] = @ARPFinalProposalID
END 
 
BEGIN 
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

SET NOCOUNT OFF
END
END
GO
