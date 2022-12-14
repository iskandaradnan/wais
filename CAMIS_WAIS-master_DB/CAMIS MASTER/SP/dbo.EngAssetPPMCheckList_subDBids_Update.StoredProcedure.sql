USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[EngAssetPPMCheckList_subDBids_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
create PROCEDURE [dbo].[EngAssetPPMCheckList_subDBids_Update]  
(  
 @pSub_PPMCheckListId int,
 @pPPMCheckListId int
)   
AS   
  
-- Exec [UpdateUserRole]   
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : UpdateUserRole  
--DESCRIPTION  : SAVE RECORD IN UMUSERROLE TABLE   
--AUTHORS   : BIJU NB  
--DATE    : 19-March-2018  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--BIJU NB           : 19-March-2018 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
 update EngAssetPPMCheckList set Sub_PPMCheckListId=@pSub_PPMCheckListId where PPMCheckListId=@pPPMCheckListId
  
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
