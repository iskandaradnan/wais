USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSWeighingScaleMst_Update]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[LLSWeighingScaleMst_Update]                                             
                  
(                  
 @IssuedBy As nvarchar(300)     
,@ItemDescription AS VARCHAR(100)        
,@IssuedDate DATETIME        
,@ExpiryDate DATETIME     
,@Status AS INT   
,@WeighingScaleId AS INT       
,@ModifiedBy as int
)                        
                  
AS                        
                  
BEGIN                  
SET NOCOUNT ON                  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                  
BEGIN TRY                  
                
DECLARE @Table TABLE (ID INT)                  
                
UPDATE   LLSWeighingScaleMst              
SET                
 IssuedBy = @IssuedBy,                
 ItemDescription = @ItemDescription,                
 IssuedDate = @IssuedDate,                
 ExpiryDate = @ExpiryDate,                
 Status = @Status,                
 ModifiedBy = @ModifiedBy,                
 ModifiedDate = GETDATE(),                
 ModifiedDateUTC = GETUTCDATE()   
WHERE WeighingScaleId = @WeighingScaleId                  
                
SELECT WeighingScaleId                
      ,[Timestamp]                
   ,'' ErrorMsg                
      --,GuId                 
FROM LLSWeighingScaleMst WHERE WeighingScaleId IN (SELECT ID FROM @Table)                  
                  
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END
GO
