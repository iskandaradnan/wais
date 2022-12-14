USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_MstDedIndicator_GetByServiceId]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
CREATE PROCEDURE  [dbo].[uspFM_MstDedIndicator_GetByServiceId]       
                                     
  @pServiceId      INT        
                   
AS                                                            
              
BEGIN TRY              
                                      
 SET NOCOUNT ON; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;              
       select * from MstDedIndicatorDet  
 LEFT JOIN MstDedIndicator     AS MstDedInd   WITH(NOLOCK) ON MstDedIndicatorDet.IndicatorId   = MstDedInd.IndicatorId         
 where      MstDedInd.ServiceId= @pServiceId    
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
