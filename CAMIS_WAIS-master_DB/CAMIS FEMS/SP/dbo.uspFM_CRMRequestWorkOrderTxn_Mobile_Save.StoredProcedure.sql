USE [UetrackFemsdbPreProd]
GO
/****** Object:  StoredProcedure [dbo].[uspFM_CRMRequestWorkOrderTxn_Mobile_Save]    Script Date: 20-09-2021 16:56:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*========================================================================================================
Application Name	: UETrack-BEMS              
Version				: 1.0
Procedure Name		: uspFM_CRMRequestWorkOrderTxn_Mobile_Save
Description			: CRM	RequestWorkOrder save
Authors				: Dhilip V
Date				: 17-July-2018
-----------------------------------------------------------------------------------------------------------

Unit Test:
DECLARE @pCRMRequestWO udt_CRMRequestWorkOrderTxn_Mobile
INSERT INTO @pCRMRequestWO ([CRMRequestWOId],[CustomerId],[FacilityId],[ServiceId],[CRMWorkOrderNo],[CRMWorkOrderDateTime],[Status],[Description],[TypeOfRequest]
,[CRMRequestId],[AssetId],[ManufacturerId],[ModelId],[AssignedUserId],[Remarks],[UserId],[Timestamp],[UserAreaId],[UserLocationId])
VALUES (137,1,1,2,'CRM/WO/PAN102/201807/000006','2018-07-03 18:32:50.310',139,'Description',134,40,null,1,1,1,null,1,null,1,1)

EXECUTE [uspFM_CRMRequestWorkOrderTxn_Mobile_Save] @pCRMRequestWO=@pCRMRequestWO

SELECT * FROM CRMRequest
SELECT * FROM CRMRequestWorkOrderTxn WHERE CRMRequestId=40
SELECT * FROM CRMRequestProcessStatus
-----------------------------------------------------------------------------------------------------------
Version History 
-----:------------:---------------------------------------------------------------------------------------
Init :  Date       : Details
========================================================================================================*/

CREATE PROCEDURE  [dbo].[uspFM_CRMRequestWorkOrderTxn_Mobile_Save]

		@pCRMRequestWO						udt_CRMRequestWorkOrderTxn_Mobile	READONLY

AS                                              

BEGIN TRY

	DECLARE @mTRANSCOUNT INT = @@TRANCOUNT

	BEGIN TRANSACTION

-- Paramter Validation 

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Declaration
	
	DECLARE @Table TABLE (ID INT)	
	DECLARE	@PrimaryKeyId	 INT


	UPDATE	CRMWO SET	CRMWO.Description			= udt_CRMWO.Description,
						CRMWO.TypeOfRequest			= udt_CRMWO.TypeOfRequest,
						CRMWO.CRMRequestId			= udt_CRMWO.CRMRequestId,
						CRMWO.AssetId				= udt_CRMWO.AssetId,
						CRMWO.AssignedUserId		= udt_CRMWO.AssignedUserId,
						CRMWO.Remarks				= udt_CRMWO.Remarks,
						CRMWO.ManufacturerId		= udt_CRMWO.ManufacturerId,
						CRMWO.ModelId				= udt_CRMWO.ModelId,
						CRMWO.Status				= udt_CRMWO.Status,
						CRMWO.UserAreaId			= udt_CRMWO.UserAreaId,
						CRMWO.UserLocationId		= udt_CRMWO.UserLocationId,
						CRMWO.ModifiedBy			= udt_CRMWO.UserId,
						CRMWO.ModifiedDate			= GETDATE(),
						CRMWO.ModifiedDateUTC		= GETUTCDATE()

						OUTPUT INSERTED.CRMRequestWOId INTO @Table
	FROM	CRMRequestWorkOrderTxn AS CRMWO WITH(NOLOCK)
			INNER JOIN @pCRMRequestWO AS udt_CRMWO ON CRMWO.CRMRequestWOId	=	udt_CRMWO.CRMRequestWOId
	


			INSERT INTO CRMRequestProcessStatus (	CustomerId,
													FacilityId,
													ServiceId,
													CRMRequestWOId,
													Status,
													DoneBy,
													DoneDate,
													CreatedBy,
													CreatedDate,
													CreatedDateUTC,
													ModifiedBy,
													ModifiedDate,
													ModifiedDateUTC
												)
			SELECT	CRMWO.CustomerId,
					CRMWO.FacilityId,
					CRMWO.ServiceId,
					CRMWO.CRMRequestWOId,
					CRMWO.Status,
					CRMWO.ModifiedBy,
					CRMWO.ModifiedDate,
					udt_CRMWO.UserId,
					GETDATE(),
					GETUTCDATE(),
					udt_CRMWO.UserId,
					GETDATE(),
					GETUTCDATE()
			FROM	CRMRequestWorkOrderTxn AS CRMWO WITH(NOLOCK)
			INNER JOIN @pCRMRequestWO AS udt_CRMWO ON CRMWO.CRMRequestWOId	=	udt_CRMWO.CRMRequestWOId
			LEFT JOIN CRMRequestProcessStatus AS ReqProcessStatus ON CRMWO.CRMRequestWOId = ReqProcessStatus.CRMRequestWOId AND udt_CRMWO.Status <> ReqProcessStatus.Status
			WHERE ReqProcessStatus.CRMRequestWOId IS NULL
								
			SELECT	CRMRequestWOId,
					CRMRequestId,
					[Timestamp],
					'' AS	ErrorMessage
			FROM	CRMRequestWorkOrderTxn
			WHERE	CRMRequestWOId IN (SELECT ID FROM @Table)
					



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
