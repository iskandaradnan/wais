USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_MstLocationUserArea_ActiveCheck]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
CREATE PROCEDURE [dbo].[UspFM_MstLocationUserArea_ActiveCheck]  
(  
 @pUserAreaId INT  
)  
   
AS   
  
-- Exec UspFM_MstLocationUserArea_ActiveCheck @pUserAreaId=1  
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : GetUserRoleTimestamp  
--DESCRIPTION  :   
--AUTHORS   :   
--DATE    :   
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--          : :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
  
  
  DECLARE @Cnt INT;  
  DECLARE @ReturnVal BIT = 0;  
  
   SELECT @Cnt = COUNT(1)   
   FROM MstLocationUserLocation   
   WHERE (Active=1)  
     AND UserAreaId = @pUserAreaId  
   IF (@Cnt>0)  
    BEGIN  
     SET @ReturnVal =1  
     SELECT @ReturnVal  isExisting  
    END  
   ELSE  
    BEGIN  
     SET @ReturnVal =0  
     SELECT @ReturnVal isExisting  
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
