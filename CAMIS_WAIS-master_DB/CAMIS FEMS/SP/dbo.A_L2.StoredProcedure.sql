USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[A_L2]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------  
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
-- =============================================    
-- Author  : Krishna S
-- Create date :08-06-2018    
-- Description :VVF approve Details    
-- =============================================    
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            
EXEC [usp_QAPPerformanceIndicatorSummary] @ParamName = 'Year', @ParamValue = 1
EXEC [usp_QAPPerformanceIndicatorSummary] @facilityid = 2, @Indicator= 2, @FromMonth =8 , @FromYear = 2018
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/           
  
CREATE PROCEDURE [dbo].[A_L2]( 
																									
													@AssetNo			VARCHAR(500) = ''
													
													
															)  
AS  
BEGIN  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
BEGIN TRY  
Select AssetId, AssetNo  from EngAsset where AssetNo = @AssetNo


END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(Spname,ErrorMessage,createddate)    
  values(OBJECT_NAME(@@PROCID),'Error_line: '+CONVERT(VARCHAR(10),error_line())+' - '+error_message(),getdate())    
    
END CATCH    
SET NOCOUNT OFF    
END
GO
