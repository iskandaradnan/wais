USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSUserAreaDetailsLinenItemMstDet_FetchLinenCode]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[LLSUserAreaDetailsLinenItemMstDet_FetchLinenCode]          
(          
 @pLinenCode nvarchar(50) ,      
 @pFacilityId INT,       
@pPageIndex    INT,        
@pPageSize    INT       
    
)          
           
AS           
          
-- Exec LLSUserAreaDetailsLinenItemMstDet_FetchLinenCode 'B',10         
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack          
--NAME    : GetAreaDetails          
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID          
--AUTHORS   : BIJU NB          
--DATE    : 20-March-2018          
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--BIJU NB           : 20-March-2018 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
BEGIN          
SET NOCOUNT ON          
SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
BEGIN TRY          
    
DECLARE @TotalRecords INT       
SELECT  @TotalRecords = COUNT(*)        
FROM dbo.LLSLinenItemDetailsMst  A        
WHERE ((ISNULL(@pLinenCode,'') = '' ) OR (ISNULL(@pLinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @pLinenCode + '%'  OR A.LinenCode LIKE + '%' + @pLinenCode + '%' )))             
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))        
AND ISNULL(A.IsDeleted,'')=''           
    
    
      
SELECT       
              FacilityId            
             ,LinenItemId      
             ,LinenCode        
             ,LinenDescription   
    ,@TotalRecords AS TotalRecords  
        
FROM dbo.LLSLinenItemDetailsMst  A        
WHERE ((ISNULL(@pLinenCode,'') = '' ) OR (ISNULL(@pLinenCode,'') <> '' AND ( A.LinenCode LIKE + '%' + @pLinenCode + '%'  OR A.LinenCode LIKE + '%' + @pLinenCode + '%' )))             
AND ((ISNULL(@pFacilityId,'')='' )  OR (ISNULL(@pFacilityId,'') <> '' AND A.FacilityId = @pFacilityId))        
AND ISNULL(A.IsDeleted,'')=''
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
