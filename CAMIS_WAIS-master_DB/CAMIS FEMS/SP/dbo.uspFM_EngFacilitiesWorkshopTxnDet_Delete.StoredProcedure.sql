USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_EngFacilitiesWorkshopTxnDet_Delete]    Script Date: 20-09-2021 16:56:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngFacilitiesWorkshopTxnDet_Delete
Description			: To Delete Contract Out Register from EngFacilitiesWorkshopTxnDet table.
Authors				: Balaji M S
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC uspFM_EngFacilitiesWorkshopTxnDet_Delete  @pFacilitiesWorkshopDetId ='88,89'


select * from EngFacilitiesWorkshopTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_EngFacilitiesWorkshopTxnDet_Delete]                           
	@pFacilitiesWorkshopDetId	NVARCHAR(250)	
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

	DELETE FROM EngFacilitiesWorkshopTxnDet 
	WHERE FacilitiesWorkshopDetId IN (SELECT ITEM FROM dbo.[SplitString] (@pFacilitiesWorkshopDetId,','))


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
