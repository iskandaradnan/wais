USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserRegistration_Employee_DuplicateCheck]    Script Date: 20-09-2021 16:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*========================================================================================================    
Application Name : UETrack-BEMS                  
Version    : 1.0    
Procedure Name  : uspFM_UMUserRegistration_Employee_DuplicateCheck    
Description   : EmployeId Duplicate check    
Authors    :Srinivas Gangula  
Date    : 13-August-2020    
-----------------------------------------------------------------------------------------------------------    
    
Unit Test:    
Declare @IsDuplicate BIT     
Exec [uspFM_UMUserRegistration_Employee_DuplicateCheck] @pUserRegistrationId=0, @pEmployeId='K9205580',@IsDuplicate=@IsDuplicate OUT    
SELECT @IsDuplicate    
    
SELECT * FROM UMUserRegistration    
-----------------------------------------------------------------------------------------------------------    
Version History     
-----:------------:---------------------------------------------------------------------------------------    
Init : Date       : Details    
========================================================================================================*/    
    
    
CREATE PROCEDURE [dbo].[uspFM_UMUserRegistration_Employee_DuplicateCheck]    
    
 @pUserRegistrationId INT,    
 @pEmployeId NVARCHAR(100),    
 @IsDuplicate BIT OUTPUT    
    
     
AS     
    
BEGIN TRY    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    
     
 SET @IsDuplicate = 1;    
 DECLARE @Cnt INT;    
    
 IF (@pUserRegistrationId = 0)    
 SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE Employee_ID = @pEmployeId    
 ELSE    
 SELECT @Cnt = COUNT(1) FROM UMUserRegistration WHERE Employee_ID = @pEmployeId AND UserRegistrationId <> @pUserRegistrationId    
    
 IF (@Cnt = 0) SET @IsDuplicate = 0;    
 ELSE SET @IsDuplicate = 1;    
     
END TRY    
BEGIN CATCH    
    
INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)    
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());    
    
THROW    
    
END CATCH    
SET NOCOUNT OFF
GO
