USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLocationMstDet_LocId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC LLSUserAreaDetailsLocationMstDet_LocId 354,5581
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLocationMstDet_LocId]
@UserAreaCode VARCHAR(100)
,@UserLocationCode VARCHAR(100)

AS

BEGIN

BEGIN TRY

DECLARE @Table TABLE (ID INT)        

SELECT LLSUserAreaLocationId,UserLocationCode FROM LLSUserAreaDetailsLocationMstDet B
WHERE UserAreaCode=@UserAreaCode
AND UserLocationCode=@UserLocationCode

SELECT LLSUserAreaLocationId      
      ,[Timestamp]      
   ,'' ErrorMsg      
      --,GuId       
FROM LLSUserAreaDetailsLocationMstDet WHERE LLSUserAreaLocationId IN (SELECT ID FROM @Table)        


END TRY

BEGIN CATCH
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)        
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());        
        
THROW        



END CATCH
SET NOCOUNT OFF        
END
GO
