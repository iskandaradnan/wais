USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserLocationQRCode_Report]    Script Date: 20-09-2021 16:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_EngMaintenanceWorkOrderTxn_Save
Description			: If Maintenance Work Order already exists then update else insert.
Authors				: Balaji M S
Date				: 09-April-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:

EXECUTE [uspFM_UserLocationQRCode_Report] @pFacilityId=1

select * from QRCodeUserLocation
SELECT * FROM MstLocationUserLocation
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UserLocationQRCode_Report]
	@pFacilityId INT = NULL	
AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @mBatchId INT

	SELECT @mBatchId	=	MAX(cast(BatchGenerated as int))  FROM QRCodeUserLocation WHERE FacilityId	=	@pFacilityId


	SELECT	
			B.UserLocationCode +' '+'+'+' '+ CAST(B.GuId AS NVARCHAR(MAX)) AS SequenceNo,B.UserLocationCode,
			B.UserLocationName,
			E.UserAreaCode,
			E.UserAreaName,
			B.QRCode,
			C.CustomerName,
			d.FacilityName 
	FROM	QRCodeUserLocation A 
			INNER JOIN MstLocationUserLocation B ON A.UserLocationId = B.UserLocationId
			INNER JOIN MstLocationFacility D ON B.FacilityId = D.FacilityId
			INNER JOIN MstCustomer C ON C.CustomerId = b.CustomerId 
			INNER JOIN MstLocationUserArea E ON B.UserAreaId = E.UserAreaId
	WHERE	A.BatchGenerated	= @mBatchId
			AND  A.FacilityId	=	@pFacilityId
	ORDER BY A.QRCodeUserLocationId




	IF @mTRANSCOUNT = 0
        BEGIN
            COMMIT
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
				'Error_line: '+CONVERT(VARCHAR(10),	error_line())+' - '+error_message(),
				getdate()
		   );
THROW;
END CATCH
GO
