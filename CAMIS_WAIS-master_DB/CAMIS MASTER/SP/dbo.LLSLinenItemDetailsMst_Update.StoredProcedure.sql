USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenItemDetailsMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

          
-- Exec [LLSLinenItemDetailsMst_Update]           
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack 1.5          
--NAME    : SaveUserAreaDetailsLLS         
--DESCRIPTION  : UPDATE RECORD IN [LLSLinenItemDetailsMst] TABLE           
--AUTHORS   : SIDDHANT          
--DATE    : 8-JAN-2020        
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--SIDDHANT          : 8-JAN-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
        
          
        
        
          
CREATE PROCEDURE  [dbo].[LLSLinenItemDetailsMst_Update]                                     
          
(          
 @LinenDescription AS NVARCHAR(600)      
,@UOM AS INT      
,@Status AS INT      
,@Material AS INT      
,@EffectiveDate AS DATETIME      
,@Size AS NVARCHAR(400)      
,@Colour AS INT      
,@IdentificationMark AS NVARCHAR(400)      
,@Standard AS INT  
,@LinenPrice AS NVARCHAR(250)      
,@ModifiedBy AS INT      
,@LinenItemId   AS INT      
      
)                
          
AS                
          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
        
DECLARE @Table TABLE (ID INT)          
        
UPDATE LLSLinenItemDetailsMst        
SET        
 LinenDescription = @LinenDescription,        
 UOM = @UOM,        
 Status = @Status,        
 Material = @Material,        
 EffectiveDate = @EffectiveDate,        
 Size = @Size,        
 Colour = @Colour,        
 IdentificationMark = @IdentificationMark,        
 Standard = @Standard,    
 LinenPrice=@LinenPrice,  
 ModifiedBy = @ModifiedBy,        
ModifiedDate = GETDATE(),        
 ModifiedDateUTC = GETUTCDATE()        
WHERE LinenItemId = @LinenItemId        
        
SELECT LinenItemId        
      ,[Timestamp]        
   ,'' ErrorMsg        
      --,GuId         
FROM LLSLinenItemDetailsMst WHERE LinenItemId IN (SELECT ID FROM @Table)          
          
END TRY          
BEGIN CATCH          
          
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)          
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());          
          
THROW          
          
END CATCH          
SET NOCOUNT OFF          
END
GO
