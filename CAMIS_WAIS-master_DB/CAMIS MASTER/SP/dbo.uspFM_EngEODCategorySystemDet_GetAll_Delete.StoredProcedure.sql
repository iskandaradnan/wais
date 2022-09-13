USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODCategorySystemDet_GetAll_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODCategorySystemDet_GetAll_Delete
Description			: To Delete CategorySystem details from EngEODCategorySystemDet table.
Authors				: Dhilip V
Date				: 27-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngEODCategorySystemDet_GetAll_Delete  @pCategorySystemId	=	'2'

-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODCategorySystemDet_GetAll_Delete]                           
	@pCategorySystemId	NVARCHAR(100)		
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
		
	IF  EXISTS(SELECT  1 FROM EngEODCategorySystem A INNER JOIN EngEODCategorySystemDet B ON A.CategorySystemId = B.CategorySystemId
				INNER JOIN EngEODCaptureTxn C ON C.AssetTypeCodeId = B.AssetTypeCodeId WHERE A.CategorySystemId = @pCategorySystemId)
	BEGIN
	SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage
	END

	ELSE
	BEGIN
	DELETE FROM  EngEODCategorySystemDet WHERE CategorySystemId =@pCategorySystemId
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

	--SELECT 'This record can''t be deleted as it is referenced by another screen'	AS ErrorMessage

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
