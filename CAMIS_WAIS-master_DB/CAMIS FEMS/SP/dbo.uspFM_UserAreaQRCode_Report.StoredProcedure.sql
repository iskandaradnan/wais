USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_UserAreaQRCode_Report]    Script Date: 20-09-2021 16:56:54 ******/
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

EXECUTE [uspFM_UserAreaQRCode_Report] @pFacilityId=1

select * from QRCodeUserArea
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_UserAreaQRCode_Report]
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

	SELECT @mBatchId	=	MAX(cast(BatchGenerated as int) )  FROM QRCodeUserArea WHERE FacilityId	=	@pFacilityId


	SELECT	B.UserAreaCode +' '+'+'+' '+ CAST(B.GuId AS NVARCHAR(MAX)) AS SequenceNo,
			B.UserAreaCode,
			B.UserAreaName,
			B.QRCode,
			C.CustomerName,
			d.FacilityName 
	FROM	QRCodeUserArea A 
			INNER JOIN MstLocationUserArea B ON A.UserAreaId = B.UserAreaId
			INNER JOIN MstLocationFacility D ON B.FacilityId = D.FacilityId
			INNER JOIN MstCustomer C ON C.CustomerId = b.CustomerId 
	WHERE	A.BatchGenerated	= @mBatchId
			AND  A.FacilityId	=	@pFacilityId
	ORDER BY A.QRCodeUserAreaId



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
