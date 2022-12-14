USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDetSingle_Delete]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--/*=====================================================================================================================        
--APPLICATION  : UETrack 1.5        
--NAME    : LLSUserAreaDetailsLinenItemMstDetSingle_Delete       
--DESCRIPTION  : DELETE RECORD SINGLE RECORD (UPDATE ISELDETED COLUMN) IN [LLSUserAreaDetailsLinenItemMstDet] TABLE         
--AUTHORS   : SIDDHANT        
--DATE    : 27-MAR-2020      
-------------------------------------------------------------------------------------------------------------------------        
--VERSION HISTORY         
--------------------:---------------:---------------------------------------------------------------------------------------        
--Init    : Date          : Details        
--------------------:---------------:---------------------------------------------------------------------------------------        
--SIDDHANT          : 27-MAR-2020 :         
-------:------------:----------------------------------------------------------------------------------------------------*/        
      
        
      
      
        
CREATE PROCEDURE  [dbo].[LLSUserAreaDetailsLinenItemMstDetSingle_Delete]                                   
        
(        
@ID NVARCHAR(250)       
,@ModifiedBy INT
)              
        
AS              
        
BEGIN        
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
BEGIN TRY        
        
 DECLARE @mTRANSCOUNT INT = @@TRANCOUNT        
        
 BEGIN TRANSACTION        
        
-- Paramter Validation         
        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;        
        
-- Declaration        
        
        
-- Default Values        
        
        
-- Execution        
        
 --DELETE FROM [dbo].LLSUserAreaDetailsLinenItemMstDet         
 --WHERE LLSUserAreaLinenItemId       
 --IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))        
        
  
UPDATE A  
SET A.IsDeleted=1  
,A.ModifiedBy=@ModifiedBy
FROM [dbo].LLSUserAreaDetailsLinenItemMstDet A         
WHERE LLSUserAreaLinenItemId       
IN (SELECT ITEM FROM dbo.[SplitString] (@ID,','))        
  
        
 IF @mTRANSCOUNT = 0        
        BEGIN        
            COMMIT TRANSACTION        
        END           
        
        
END TRY        
        
BEGIN CATCH        
        
 IF @mTRANSCOUNT = 0        
        BEGIN        
            ROLLBACK TRAN        
        END        
        
 SELECT 'This record can''t be deleted as it is referenced by another screen' AS ErrorMessage        
        
 INSERT INTO ErrorLog(        
    Spname,        
    ErrorMessage,        
    createddate)        
 VALUES(  OBJECT_NAME(@@PROCID),        
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),        
    getdate()        
     );        
     THROW;        
        
END CATCH      
END
GO
