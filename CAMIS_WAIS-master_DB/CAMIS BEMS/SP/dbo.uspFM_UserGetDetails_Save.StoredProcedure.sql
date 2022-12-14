USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserGetDetails_Save]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMChangePassword_Save
Description			: Change Password details
Authors				: Dhilip V
Date				: 18-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UserGetDetails_Save  @pEmail='user1'
select * from UMUserRegistration
select * from UMChangePassword
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UserGetDetails_Save]

	@pEmail						NVARCHAR(200)


AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)
	DECLARE @pOldPassword	NVARCHAR(max)
	DECLARE @pUserRegistrationId  INT
	DECLARE @pUserIdget  INT
-- Default Values


-- Execution


	IF (@pEmail IS NOT NULL)
		BEGIN

		SELECT StaffName,[Password],Email,UserName FROM UMUserRegistration WHERE Email = @pEmail

		END
	
	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT TRANSACTION
        END   


END TRY

BEGIN CATCH

	IF @mTRANSCOUNT = 0
        BEGIN
            ROLLBACK TRAN
        END

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'ERROR_LINE: '+CONVERT(VARCHAR(10),	ERROR_LINE())+' - '+ERROR_MESSAGE(),
				GETDATE()
		   )

END CATCH
GO
