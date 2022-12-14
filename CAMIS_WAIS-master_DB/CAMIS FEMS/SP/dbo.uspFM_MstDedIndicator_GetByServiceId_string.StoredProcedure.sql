USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstDedIndicator_GetByServiceId_string]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec uspFM_MstDedIndicator_GetByServiceId_string 18


create PROCEDURE  [dbo].[uspFM_MstDedIndicator_GetByServiceId_string]           
                                         
  @pIndicators      varchar(500)    null        
                       
AS                                                                
                  
BEGIN TRY                  
                                      
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;                  
        
   select Comp.IndicatorDetId,Comp.IndicatorNo,comp.IndicatorDesc from  dbo.SplitString (@pIndicators,',') AS SplitComp            
   LEFT JOIN MstDedIndicatorDet AS Comp  WITH(NOLOCK) ON Comp.IndicatorDetId = SplitComp.Item     
    
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
