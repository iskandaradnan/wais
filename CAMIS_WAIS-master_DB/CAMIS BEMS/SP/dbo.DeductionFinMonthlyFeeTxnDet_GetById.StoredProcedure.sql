USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionFinMonthlyFeeTxnDet_GetById]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
CREATE PROCEDURE [dbo].[DeductionFinMonthlyFeeTxnDet_GetById]            
(            
 @Id INT            
)            
             
AS             
    -- Exec [FinMonthlyFeeTxnDet_GetById] 2020         
          
--/*=====================================================================================================================          
--APPLICATION  : UETrack          
--NAME    : FinMonthlyFeeTxnDet_GetById         
--DESCRIPTION  : GETS THE FinMonthlyFeeTxnDet DETAILS          
--AUTHORS   : SIDDHANT          
--DATE    : 8-JAN-2020          
-------------------------------------------------------------------------------------------------------------------------          
--VERSION HISTORY           
--------------------:---------------:---------------------------------------------------------------------------------------          
--Init    : Date          : Details          
--------------------:---------------:---------------------------------------------------------------------------------------          
--AIDA NAZRI           : 3-MAR-2020 :           
-------:------------:----------------------------------------------------------------------------------------------------*/          
          
BEGIN            
SET NOCOUNT ON            
SET TRANSACTION ISOLATION LEVEL READ COMMITTED            
BEGIN TRY            
             
SELECT        
  A.Year   
  ,B.MonthlyFeeDetId  
 ,B.Month      
 ,B.BemsMSF     
 ,B.ProHawkBemsMSF  
FROM        
 dbo.FinMonthlyFeeTxn A        
INNER JOIN      
 dbo.FinMonthlyFeeTxnDet AS B ON A.MonthlyFeeId =B.MonthlyFeeId        
WHERE A.Year=@Id          
      
      
END TRY            
BEGIN CATCH            
            
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)            
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());            
            
THROW            
            
END CATCH            
SET NOCOUNT OFF            
END


GO
