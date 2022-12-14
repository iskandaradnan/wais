USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[Master_Update_Master_UserRegID]    Script Date: 20-09-2021 16:42:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[Master_Update_Master_UserRegID]
(
	@Master_UserRegID       AS INT,
	@Module_ID As int,
	@Module_Type As int
	
)	
AS 

--select * from UMUserRegistration_Mapping

-- Exec [Master_Update_Master_UserRegID] 1,5,6

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: UpdateUser
--DESCRIPTION		: SAVE RECORD IN help for cross db mapping TABLE 
--AUTHORS			: Vijay
--DATE				: 18-Sep-2019
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 18-Sep-2019 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY

	if(@Module_Type = 2)

			UPDATE A SET A.BEMS = @Module_ID
			 FROM UMUserRegistration_Mapping A 
			 WHERE A.Master_UserRegistrationId = @Master_UserRegID
	
    		

	if(@Module_Type = 1)

			UPDATE A SET A.FEMS = @Module_ID
			  FROM UMUserRegistration_Mapping A 
			 WHERE A.Master_UserRegistrationId = @Master_UserRegID

	if(@Module_Type = 3)

			UPDATE A SET A.CLS = @Module_ID
			 FROM UMUserRegistration_Mapping A 
			 WHERE A.Master_UserRegistrationId = @Master_UserRegID

	

END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());

THROW

END CATCH
SET NOCOUNT OFF
END
GO
