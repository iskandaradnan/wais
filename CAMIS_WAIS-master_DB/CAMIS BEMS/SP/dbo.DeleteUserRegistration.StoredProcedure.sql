USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[DeleteUserRegistration]    Script Date: 20-09-2021 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeleteUserRegistration]
(
	@Id INT
)
	
AS 

-- Exec [DeleteUserRegistration] 

--/*=====================================================================================================================
--APPLICATION		: UETrack
--NAME				: DeleteUserRegistration
--DESCRIPTION		: DELETE USER ROLE
--AUTHORS			: BIJU NB
--DATE				: 20-March-2018
-------------------------------------------------------------------------------------------------------------------------
--VERSION HISTORY 
--------------------:---------------:---------------------------------------------------------------------------------------
--Init				: Date          : Details
--------------------:---------------:---------------------------------------------------------------------------------------
--BIJU NB           : 20-March-2018 : 
-------:------------:----------------------------------------------------------------------------------------------------*/
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
	BEGIN TRAN

	DELETE FROM UMUserLocationMstDet WHERE UserRegistrationId = (SELECT UserRegistrationId FROM UMUserRegistration WHERE UserRegistrationId = @Id)
	DELETE FROM UMUserRegistration  WHERE UserRegistrationId = @Id

	COMMIT TRAN
END TRY
BEGIN CATCH

INSERT INTO ErrorLog(SpName,ErrorMessage,CreatedDate)
VALUES (OBJECT_NAME(@@PROCID),'Error_line: '+ CONVERT(VARCHAR(10),error_line()) + ' - '+error_message(),getdate());
ROLLBACK;

THROW

END CATCH
SET NOCOUNT OFF
END
GO
