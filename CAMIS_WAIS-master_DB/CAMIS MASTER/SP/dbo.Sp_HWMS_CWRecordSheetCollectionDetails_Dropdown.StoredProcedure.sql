USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Sp_HWMS_CWRecordSheetCollectionDetails_Dropdown]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE  [dbo].[Sp_HWMS_CWRecordSheetCollectionDetails_Dropdown]                              
  @pScreenName nvarchar(400)    
      
AS                                                  
    
BEGIN TRY    
    
 SET NOCOUNT ON;     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
 IF(@pScreenName = 'CWRecordSheet')    
 BEGIN    
    
  --SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)    
  --WHERE Active = 1  AND LovKey='CollectionStatusValues' and ScreenName = @pScreenName    
  SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)    
  WHERE Active = 1  AND LovKey='CollectionStatusValues' AND SCREENNAME = @pScreenName     
    
     SELECT LovId  AS LovId, FieldValue AS FieldValue, IsDefault  FROM FMLovMst WITH(NOLOCK)    
  WHERE Active = 1  AND LovKey='SanitizeValues'  and  ScreenName = @pScreenName    
  ORDER BY LovId DESC  
    
  SELECT LovId, FieldValue, IsDefault FROM FMLovMst WITH(NOLOCK)    
  WHERE Active = 1  AND LovKey='QcValues'     
 END          
END TRY    
BEGIN CATCH    
    
 INSERT INTO ErrorLog(    
    Spname,    
    ErrorMessage,    
    createddate)    
 VALUES(  OBJECT_NAME(@@PROCID),    
    'Error_line: '+CONVERT(VARCHAR(10), error_line())+' - '+error_message(),    
    getdate()    
     )    
    
END CATCH
GO
