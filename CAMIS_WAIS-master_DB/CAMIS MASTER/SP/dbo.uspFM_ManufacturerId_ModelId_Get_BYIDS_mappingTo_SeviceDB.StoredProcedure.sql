USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_ManufacturerId_ModelId_Get_BYIDS_mappingTo_SeviceDB]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[uspFM_ManufacturerId_ModelId_Get_BYIDS_mappingTo_SeviceDB]  
(    
@pManufacturerId INT,  
 @pModelId  INT  
 )  
AS   
  
-- Exec [GetUserRole]   
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : GetUserRole  
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID  
--AUTHORS   : ADV NB  
--DATE    : 20-March-2019  
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
   
  SELECT AssetStandardizationId_mappingTo_SeviceDB,ManufacturerId_mappingTo_SeviceDB,ModelId_mappingTo_SeviceDB
  FROM [dbo].EngAssetStandardization
  WHERE EngAssetStandardization.ManufacturerId=@pManufacturerId AND EngAssetStandardization.ModelId=@pModelId   
  
   
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
