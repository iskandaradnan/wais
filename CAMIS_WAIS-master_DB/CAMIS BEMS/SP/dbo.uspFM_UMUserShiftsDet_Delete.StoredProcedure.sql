USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UMUserShiftsDet_Delete]    Script Date: 20-09-2021 17:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_UMUserShiftsDet_Delete
Description			: To Delete User Shifts details.
Authors				: Dhilip V
Date				: 18-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_UMUserShiftsDet_Delete  @pUserShiftDetId ='53'

UPDATE UMUserShiftsDet SET LeaveTo='2018-07-18 00:00:00.000' WHERE UserShiftDetId=53
select * from UMUserShiftsDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UMUserShiftsDet_Delete]                           
	@pUserShiftDetId	NVARCHAR(250)	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration


-- Default Values


-- Execution

	--SELECT * FROM UMUserShiftsDet
	--WHERE	UserShiftDetId IN (SELECT ITEM FROM dbo.[SplitString] (@pUserShiftDetId,','))
	--		AND LeaveTo !< GETDATE()

	DELETE FROM UMUserShiftsDet 
	WHERE UserShiftDetId IN (SELECT ITEM FROM dbo.[SplitString] (@pUserShiftDetId,','))
	AND LeaveTo !< CONVERT(date, getdate())


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

	SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage

	INSERT INTO ErrorLog(
				Spname,
				ErrorMessage,
				createddate)
	VALUES(		OBJECT_NAME(@@PROCID),
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
		   THROW;

END CATCH
GO
