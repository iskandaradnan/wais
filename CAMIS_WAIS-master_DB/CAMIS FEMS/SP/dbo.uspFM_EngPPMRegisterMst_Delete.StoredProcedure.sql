USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngPPMRegisterMst_Delete]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngPPMRegisterMst_Delete
Description			: Delete the PPMRegister Details
Authors				: Dhilip V
Date				: 07-mAY-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngPPMRegisterMst_Delete  @pPPMId=21
SELECT * FROM EngPPMRegisterMst where PPMId=21
SELECT * FROM EngPPMRegisterHistoryMst where PPMId=21
SELECT * FROM FMDocument where DocumentId in (SELECT DocumentId FROM EngPPMRegisterHistoryMst where PPMId=21)
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngPPMRegisterMst_Delete]                           
	@pPPMId	INT	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @Table TABLE (ID INT)

-- Execution

	--Get document Id's from History table
	INSERT INTO @Table (ID)
	SELECT DocumentId FROM EngPPMRegisterHistoryMst WHERE PPMId	= @pPPMId

	-- Delete from History
	DELETE FROM  EngPPMRegisterHistoryMst	WHERE PPMId	= @pPPMId

	--Document table delete
	DELETE FROM  FMDocument	WHERE DocumentId IN (SELECT ID FROM @Table)

	DELETE FROM  EngPPMRegisterMst	WHERE PPMId	= @pPPMId


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
		   )

END CATCH
GO
