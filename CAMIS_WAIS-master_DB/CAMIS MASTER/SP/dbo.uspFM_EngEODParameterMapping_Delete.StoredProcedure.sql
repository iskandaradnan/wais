USE [UetrackMasterdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngEODParameterMapping_Delete]    Script Date: 20-09-2021 16:43:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngEODParameterMapping_Delete
Description			: To Delete EODParameterMapping details from MstQAPIndicator table.
Authors				: Dhilip V
Date				: 01-May-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXEC uspFM_EngEODParameterMapping_Delete  @pParameterMappingId	=	1

SELECT * FROM EngEODParameterMapping
SELECT * FROM EngEODParameterMappingDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngEODParameterMapping_Delete]  
                        
	@pParameterMappingId	INT	

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


	DELETE FROM  EngEODParameterMappingDet	WHERE ParameterMappingId	= @pParameterMappingId

	DELETE FROM  EngEODParameterMapping		WHERE ParameterMappingId	= @pParameterMappingId
	
	SELECT ''	AS ErrorMessage


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
