USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeductionMstDedIndicatorDet_GetById]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
CREATE PROCEDURE [dbo].[DeductionMstDedIndicatorDet_GetById]              
            
               
AS               
    -- Exec [DeductionMstDedIndicatorDet_GetById]            
            
--/*=====================================================================================================================            
--APPLICATION  : UETrack            
--NAME    : MstDedIndicatorDet_GetById           
--DESCRIPTION  : GETS THE MstDedIndicatorDet DETAILS            
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
 A.IndicatorDetId      
  ,A.IndicatorNo          
 ,A.IndicatorName       
 ,A.Frequency     
 ,B.FieldValue AS FrequencyName          
 ,A.IndicatorDesc      
FROM          
 dbo.MstDedIndicatorDet A          
LEFT OUTER JOIN        
 dbo.FMLovMst AS B ON A.Frequency =B.LovId          
WHERE A.Active='True'        
AND A.ServiceId=1            
END TRY              
BEGIN CATCH            


  
  
              
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)              
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());              
              
THROW              
              
END CATCH              
SET NOCOUNT OFF              
END
GO
