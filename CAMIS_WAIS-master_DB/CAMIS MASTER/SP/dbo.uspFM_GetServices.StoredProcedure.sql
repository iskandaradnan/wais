USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_GetServices]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[uspFM_GetServices]  
  
   
AS   
  
-- Exec [uspFM_GetServices]   
  
--/*=====================================================================================================================  
--APPLICATION  : UETrack  
--NAME    : GetSrevices  
--DESCRIPTION  : GET USER ROLE FOR THE GIVEN ID  
--AUTHORS   : Deepak Vijay   
--DATE    : 23-SEP-2019  
-------------------------------------------------------------------------------------------------------------------------  
--VERSION HISTORY   
--------------------:---------------:---------------------------------------------------------------------------------------  
--Init    : Date          : Details  
--------------------:---------------:---------------------------------------------------------------------------------------  
--VIJAY           : 23-SEP-2019 :   
-------:------------:----------------------------------------------------------------------------------------------------*/  
BEGIN  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
BEGIN TRY  
   
 SELECT [ServiceId] as LovId  
      ,[ServiceKey] as FieldValue  
      ,0 as IsDefault FROM [MstService]     
	     where [ServiceId]  in (1,2)
   
END TRY  
BEGIN CATCH  
  
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)  
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());  
  
THROW  
  
END CATCH  
SET NOCOUNT OFF  
END
GO
