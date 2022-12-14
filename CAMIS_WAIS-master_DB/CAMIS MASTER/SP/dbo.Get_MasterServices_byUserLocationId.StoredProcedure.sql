USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Get_MasterServices_byUserLocationId]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_MasterServices_byUserLocationId]  
(  
 @UserLocationID INT  
)  
   
AS   
 --exec Get_MasterServices_byUserLocationId 9020
-- Exec [GetUserRoleLovs]   
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : GetUserRoleLovs  
--DESCRIPTION  : GET LOV VALUES FOR USERROLE   
--AUTHORS   : BIJU NB  
--DATE    : 12-March-2018  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--BIJU NB           : 15-March-2018 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
   
 --Gets service coloums of the Selected Block  
  
SELECT UserLocationId LovId, UserLocationName FieldValue, 0  IsDefault,MstServices_Mapping_location.BEMS,MstServices_Mapping_location.FEMS,MstServices_Mapping_location.FEMS,FacilityId  
FROM MstLocationUserLocation  
LEFT JOIN MstServices_Mapping_location  
ON MstLocationUserLocation.UserLocationId = MstServices_Mapping_location.Master_Location_ID WHERE MstLocationUserLocation.UserLocationId = @UserLocationID ORDER BY MstLocationUserLocation.UserLocationName   
  
  
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
