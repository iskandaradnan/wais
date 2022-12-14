USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[LLSVehicleDetailsMst_GetById]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
                
CREATE PROCEDURE [dbo].[LLSVehicleDetailsMst_GetById]                
(                
 @Id INT                
)                
                 
AS                 
    -- Exec [LLSVehicleDetailsMst_GetById] 135             
              
--/*=====================================================================================================================              
--APPLICATION  : UETrack              
--NAME    : LLSVehicleDetailsMst_GetById             
--DESCRIPTION  : GETS THE VehicleDetails              
--AUTHORS   : SIDDHANT              
--DATE    : 13-JAN-2020              
-------------------------------------------------------------------------------------------------------------------------              
--VERSION HISTORY               
--------------------:---------------:---------------------------------------------------------------------------------------              
--Init    : Date          : Details              
--------------------:---------------:---------------------------------------------------------------------------------------              
--SIDDHANT           : 13-JAN-2020 :               
-------:------------:----------------------------------------------------------------------------------------------------*/              
              
BEGIN                
SET NOCOUNT ON                
SET TRANSACTION ISOLATION LEVEL READ COMMITTED                
BEGIN TRY                
                 
 SELECT            
 A.VehicleNo,            
 A.Model,            
 B.LovId as Manufacturer,            
 C.LaundryPlantId as LaundryPlantName,            
 D.LovId as Status,            
 A.EffectiveFrom,            
 A.EffectiveTo,            
 A.LoadWeight            
FROM            
 dbo.LLSVehicleDetailsMst A            
INNER JOIN            
 dbo.FMLovMst B ON A.Manufacturer =B.LovId            
INNER JOIN dbo.LLSLaundryPlantMst C             
 ON A.LaundryPlantId =C.LaundryPlantId            
INNER JOIN dbo.FMLovMst D             
ON A.Status =D.LovId             
WHERE VehicleId=@ID  
AND ISNULL(A.IsDeleted,'')=''
AND ISNULL(C.IsDeleted,'')=''

            
END TRY                
BEGIN CATCH                
                
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)                
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());                
                
THROW                
                
END CATCH                
SET NOCOUNT OFF                
END
GO
