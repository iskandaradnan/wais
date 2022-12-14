USE [UetrackBemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[UspFM_EngLicenseandCertificateTxnDet_Delete]    Script Date: 20-09-2021 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngLicenseandCertificateTxnDet_Delete
Description			: To Delete Stockpdate from EngLicenseandCertificateTxnDet table.
Authors				: Dhilip V
Date				: 10-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
EXEC UspFM_EngLicenseandCertificateTxnDet_Delete  @pLicenseDetId ='3119,3138'


select * from EngLicenseandCertificateTxnDet
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init : Date       : Details
========================================================================================================*/

create PROCEDURE  [dbo].[UspFM_EngLicenseandCertificateTxnDet_Delete]                           
	@pLicenseDetId	NVARCHAR(250)	
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

	DELETE FROM EngLicenseandCertificateTxnDet 
	WHERE LicenseDetId IN (SELECT ITEM FROM dbo.[SplitString] (@pLicenseDetId,','))


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
