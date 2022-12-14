USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSLinenInjectionTxn_FetchDONo]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
---EXEC [LLSLinenInjectionTxn_FetchDONo]  o           
              
CREATE PROCEDURE [dbo].[LLSLinenInjectionTxn_FetchDONo]            
@DONO AS VARCHAR(100),        
 @pPageIndex    INT,       
 @pPageSize    INT       
  
AS              
              
BEGIN              
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
              
DECLARE @TotalRecords INT       
SELECT  @TotalRecords = COUNT(*)        
FROM DBO.PMSDeliveryOrderMst  A    
WHERE ((ISNULL(@DONO,'') = '' ) OR (ISNULL(@DONO,'') <> '' AND ( A.DONo LIKE + '%' + @DONO + '%'  OR A.DONo LIKE + '%' + @DONO + '%' )))             
--AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))        
  
              
--SELECT LinenItemId,LinenCode, LinenDescription            
--FROM dbo.LLSLinenItemDetailsMst           
--Where LinenCode like '%'+@LinenCode+'%'          
--and FacilityId=@FacilityId           
      
      
SELECT DOId, DONO,DODATE,PONO , @TotalRecords AS TotalRecords     
FROM DBO.PMSDeliveryOrderMst   A   
WHERE ((ISNULL(@DONO,'') = '' ) OR (ISNULL(@DONO,'') <> '' AND ( A.DONo LIKE + '%' + @DONO + '%'  OR A.DONo LIKE + '%' + @DONO + '%' )))             
ORDER BY A.ModifiedDateUTC DESC        
OFFSET (@pPageSize *  (@pPageIndex-1))   ROWS FETCH NEXT  @pPageSize  ROWS ONLY         
  
            
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
              
            
END
GO
